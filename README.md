# Raptor: Call of the Shadows for AmigaOS 3.x / AmiCradle — TESTING

Raptor: Call of the Shadows (Cygnus Studios, 1994) is a vertical
shoot-'em-up drawn at 320x200. This repository holds skynettx's open engine,
reconstructed from the DOS game by nukeykt and others (GPL-2.0, `LICENSE`),
as imported from upstream
[skynettx/raptor](https://github.com/skynettx/raptor) at
`746c35a256bfa2afc6732c7923be9e2e777d6bf0` (identical file for file; upstream's
own README is `README.upstream.md`), and the AmiCradle port around it:
68040 + FPU, libnix, SDL2 through GFOpenGPU, OpenAmigaGCC 16.2.0-open3 or
open4. There is no network code.

The engine needs the original game data, which is not part of this
repository and never committed: see *Game data*.

## Building

The port never edits the imported tree: `build-amiga.sh` copies `src/` and
the two libraries upstream carries in `include/` (textscreen, for the setup
screens, and TinySoundFont), applies `patches/` in order with no fuzz (every
change is Amiga-only, under `__amigaos__`), and compiles upstream's source
list (`CMakeLists.txt`, setup included). It writes `Raptor/raptor`,
`Raptor/LICENSE`, `build.log` and `receipt.json` (the compiler, the patch and
SDK digests and the executable's SHA-256).

Through Cradle (the build the lab tests use): `stove_build` with the stove
`os32-gcc16`, target `.` for the program and target `runtime-data` for the
game data. From a checkout with a staged stove:

```sh
STOVE=/path/to/os32-gcc16 OUT=build-amiga sh build-amiga.sh
OUT=build-data sh runtime-data/build-amiga.sh
```

`build-amiga.sh` takes 16.2.0-open3 (compiler archive SHA-256
`9fcc136ab59e3bb5b91d2764d0bf290b709d72d7380be4ce0cdf005edf8eff21`) and
16.2.0-open4 (`495319a2ffd803278f8827cad70074029c7aa9ecbe05d037e8646ba43ab94ab2`,
Cradle's `os32-gcc16` stove since 2 November 2026) and refuses any other.
Receipts of the builds recorded here are in `receipts/`.

## Game data

Raptor needs `FILE0000.GLB` and `FILE0001.GLB` from the shareware episode
(version 1.2; the full game's `FILE0002.GLB` to `FILE0004.GLB` work too, put
beside them). The shareware episode was released by Apogee for free
distribution: its `VENDOR.DOC` lets anyone copy and pass it around without
charging for it, all files unmodified (CD-ROM, bundle and retail
distribution need Apogee's written permission).

`runtime-data/build-amiga.sh` fetches Apogee's `1rap12.zip` on the PC that
runs it, checks it and the two GLB files inside against the SHA-256 values
pinned in `gameports/runtime-data.json` (with where the file comes from and
why it is taken to be the publisher's release), and puts them in
`Raptor/` with `VENDOR.DOC`. Nothing is redistributed: the data stays
external, as the manifest's policy says.

## Observed 2 November 2026

Clean build by Cradle's `stove_build` (target `.`, `os32-gcc16` stove,
OpenAmigaGCC 16.2.0-open4) of commit `f8ddda3`, no patches yet: upstream's
source compiles and links for 68040 + FPU with no warning. Executable
SHA-256 `723be964eacc4c39eb2f883f8e2ddea53e2ec412a99b6275f2a7072e5cec05d2`
(855476 bytes); `receipts/1-build-open4-stove_build.json`. A second job at
the same commit gave the same executable and the same receipt, byte for
byte. Target
`runtime-data` fetched the pinned ZIP on the PC and staged both GLB files,
each matching its pin (`receipts/1-data.json`).

No runtime claim is made by this step. This is TESTING, not RELEASE.
