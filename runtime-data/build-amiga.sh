#!/bin/sh
# Stages Raptor's shareware episode for a lab, on the PC that runs the job
# (Cradle's stove_build, target runtime-data; STOVE= and OUT= set, the stove
# is not used). The ZIP pinned in gameports/runtime-data.json is fetched (or
# taken from RAPTOR_SHAREWARE_ZIP) and its SHA-256 checked; FILE0000.GLB and
# FILE0001.GLB come out of its inner archive, each checked against the pin,
# and go to OUT/Raptor beside where the program goes. Nothing here is
# committed or packaged: the data stays external (the manifest's policy;
# Apogee's VENDOR.DOC in the archive lets the shareware episode be copied
# freely, unmodified and without charge).
#   OUT                   the output directory (default build-data)
#   RAPTOR_SHAREWARE_ZIP  a local copy of 1rap12.zip (checked the same way)
# Outputs: Raptor/FILE0000.GLB, Raptor/FILE0001.GLB, Raptor/VENDOR.DOC (the
# shareware licence, kept beside the data it covers), data-receipt.json.
# MIT, Copyright (c) 2026 AmiCradle Team.
set -eu

HERE=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
OUT=${OUT:-"$HERE/build-data"}
WORK=$(mktemp -d "${TMPDIR:-/tmp}/raptor-data.XXXXXX")
trap 'rm -rf "$WORK"' EXIT INT TERM
mkdir -p "$OUT/Raptor"

eval "$(python3 - "$HERE/gameports/runtime-data.json" <<'PY'
import json, shlex, sys
d = json.load(open(sys.argv[1]))["datasets"]["raptor-shareware-1.2"]
print(f"ZIP_NAME={shlex.quote(d['filename'])}")
print(f"ZIP_SHA={shlex.quote(d['sha256'])}")
print(f"ZIP_URLS={shlex.quote(' '.join(d['urls']))}")
PY
)"

ZIP=${RAPTOR_SHAREWARE_ZIP:-"$WORK/$ZIP_NAME"}
if [ ! -f "$ZIP" ]; then
    for url in $ZIP_URLS; do
        echo "fetch $url"
        if curl -fsSL --retry 3 -o "$ZIP" "$url"; then break; fi
        rm -f "$ZIP"
    done
fi
[ -f "$ZIP" ] || { echo "no $ZIP_NAME from any of: $ZIP_URLS"; exit 2; }
GOT=$(sha256sum "$ZIP" | cut -d' ' -f1)
[ "$GOT" = "$ZIP_SHA" ] || { echo "$ZIP_NAME SHA-256 $GOT, pinned $ZIP_SHA"; exit 2; }
echo "$ZIP_NAME SHA-256 $GOT (pinned)"

python3 - "$HERE/gameports/runtime-data.json" "$ZIP" "$OUT" <<'PY'
import hashlib, io, json, sys, zipfile
from pathlib import Path
manifest, zip_path, out = Path(sys.argv[1]), Path(sys.argv[2]), Path(sys.argv[3])
d = json.loads(manifest.read_text())["datasets"]["raptor-shareware-1.2"]
outer = zipfile.ZipFile(zip_path)
inner = zipfile.ZipFile(io.BytesIO(outer.read(d["inner"]["archive"])))
dest = out / "Raptor"
staged = {}
for name, pinned in d["inner"]["files"].items():
    data = inner.read(name)
    got = hashlib.sha256(data).hexdigest()
    if got != pinned:
        sys.exit(f"{name} SHA-256 {got}, pinned {pinned}")
    (dest / name).write_bytes(data)
    staged[name] = {"bytes": len(data), "sha256": got}
    print(f"{name} {len(data)} bytes, SHA-256 {got} (pinned)")
# the shareware licence goes with the data it covers
vendor = inner.read("VENDOR.DOC")
(dest / "VENDOR.DOC").write_bytes(vendor)
receipt = {
    "dataset": "raptor-shareware-1.2", "archive": d["filename"],
    "archive_sha256": d["sha256"], "staged": staged,
    "vendor_doc_sha256": hashlib.sha256(vendor).hexdigest(),
    "scope": "Local lab staging only; not committed, packaged or redistributed",
}
(out / "data-receipt.json").write_text(json.dumps(receipt, indent=2) + "\n")
PY
ls -l "$OUT/Raptor"
