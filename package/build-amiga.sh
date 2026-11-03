#!/bin/sh
# The release archive, for Cradle's stove_build (target package, STOVE= and
# OUT= set): the game built as build-amiga.sh builds it, then
# tools/make_package.py: raptor-VERSION-68040.lha with its .sha256 and
# .readme, the Raptor drawer with its GlowIcons (icons/), the drawer as it
# unpacks and as Raptor.tar (for a lab), and package.json. The game data is
# not in it (gameports/catalog.json's contentPolicy): target runtime-data
# stages the shareware episode for a lab.
# VERSION is package/VERSION. Nothing is published from here.
# MIT, Copyright (c) 2026 AmiCradle Team.
set -eu

HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ROOT=$(CDPATH= cd -- "$HERE/.." && pwd)
OUT=${OUT:-"$ROOT/build-amiga-package"}
VERSION=$(cat "$HERE/VERSION")
mkdir -p "$OUT"
OUT=$(CDPATH= cd -- "$OUT" && pwd)
BUILD=$(mktemp -d "${TMPDIR:-/tmp}/raptor-package.XXXXXX")
trap 'rm -rf "$BUILD"' EXIT INT TERM

OUT=$BUILD sh "$ROOT/build-amiga.sh" > "$OUT/build-output.txt" 2>&1 || { tail -n 80 "$OUT/build-output.txt"; exit 1; }
tail -n 12 "$OUT/build-output.txt"
cp "$BUILD/receipt.json" "$OUT/receipt.json"
python3 "$ROOT/tools/make_package.py" --build "$BUILD" --version "$VERSION" --out "$OUT"
