"""tools/make_package.py: the Installer and its icon go beside the drawer.

    python3 -m unittest discover -s tests -p 'test_make_package.py'

MIT, Copyright (c) 2026 AmiCradle Team.
"""
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
import lha_archive  # noqa: E402

EXECUTE = 0x40


def spec(root):
    return {
        "drawer": "Game",
        "drawer_icon": "icons/ReadMe.info",
        "archive": "game-{version}-68040",
        "members": [{"name": "game", "build": "Game/game"}, {"name": "game.info", "repo": "icons/ReadMe.info"}],
        "root": root,
        "aminet": [["Short", "test"], ["Version", "{version}"]],
    }


class RootMembers(unittest.TestCase):
    def run_pack(self, root):
        tmp = Path(tempfile.mkdtemp())
        (tmp / "build/Game").mkdir(parents=True)
        (tmp / "build/Game/game").write_bytes(b"\0\0\3\xf3 hunk")
        (tmp / "build/receipt.json").write_text(json.dumps({"source_date_epoch": 1763337600}))
        (tmp / "spec.json").write_text(json.dumps(spec(root)))
        r = subprocess.run([sys.executable, str(ROOT / "tools/make_package.py"), "--build", str(tmp / "build"),
                            "--version", "1.0", "--out", str(tmp / "out"), "--spec", str(tmp / "spec.json")],
                           capture_output=True, text=True)
        return r, tmp / "out"

    def test_installer_beside_drawer(self):
        root = [{"name": "Install-Game", "repo": "package/build-amiga.sh", "script": True},
                {"name": "Install-Game.info", "repo": "icons/ReadMe.info"}]
        r, out = self.run_pack(root)
        self.assertEqual(r.returncode, 0, r.stderr)
        back = {m.path: m for m in lha_archive.read((out / "game-1.0-68040.lha").read_bytes())}
        self.assertEqual(sorted(p for p in back if "/" not in p), ["Game.info", "Install-Game", "Install-Game.info"])
        self.assertEqual(back["Install-Game"].protect & EXECUTE, EXECUTE)
        self.assertEqual(back["Install-Game.info"].protect & EXECUTE, 0)
        self.assertTrue((out / "Install-Game").is_file())

    def test_root_member_cannot_shadow_the_drawer(self):
        r, _ = self.run_pack([{"name": "game.INFO", "repo": "icons/ReadMe.info"}])
        self.assertNotEqual(r.returncode, 0)
        r, _ = self.run_pack([{"name": "Sub/x", "repo": "icons/ReadMe.info"}])
        self.assertNotEqual(r.returncode, 0)

    def test_root_names_ignore_case(self):
        r, _ = self.run_pack([{"name": "Install-Game", "repo": "icons/ReadMe.info"},
                              {"name": "install-game", "repo": "icons/ReadMe.info"}])
        self.assertNotEqual(r.returncode, 0)

    def test_no_root_is_as_before(self):
        r, out = self.run_pack([])
        self.assertEqual(r.returncode, 0, r.stderr)
        back = [m.path for m in lha_archive.read((out / "game-1.0-68040.lha").read_bytes())]
        self.assertEqual([p for p in back if "/" not in p], ["Game.info"])


if __name__ == "__main__":
    unittest.main()
