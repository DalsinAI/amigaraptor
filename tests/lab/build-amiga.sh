#!/bin/sh
# Lab tools for the play tests (README, "Observed"): HoldKeys, which holds
# keys down for a time. Built with the os32-gcc16 stove for Cradle's
# stove_build (target tests/lab, STOVE= and OUT= set). Not part of the port.
# MIT, Copyright (c) 2026 AmiCradle Team.
set -eu
HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
STOVE=${STOVE:-"$HOME/AmigaChrome/stoves/os32-gcc16"}
OUT=${OUT:-"$HERE/build-amiga"}
mkdir -p "$OUT"
"$STOVE/prefix/bin/m68k-amigaos-gcc" -noixemul -m68040 -O2 -Wall -Werror \
    -fno-delete-null-pointer-checks -o "$OUT/HoldKeys" "$HERE/holdkeys.c"
ls -l "$OUT/HoldKeys"
