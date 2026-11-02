# Build receipts

Each file is a `receipt.json` (or `data-receipt.json`) exactly as the build
wrote it, byte for byte (its SHA-256 is in the table), kept here because the
build output itself is not committed. `repository_commit` is the commit that
was built; the receipt is committed after it.

| File | Build | Where | Receipt SHA-256 |
|---|---|---|---|
| `1-build-open4-stove_build.json` | Cradle `stove_build`, target `.` | Cradle's `os32-gcc16` stove (open4) | `d06fe39fe4c1616a7603540f3cfde494ff32ed812290ce0b20bf10633f31787e` |
| `1-data.json` | Cradle `stove_build`, target `runtime-data` | Cradle (the same bytes from a local run with the same ZIP) | `9d21e22c984895c390273f4806f7a525533b9940079b628625e6db472445b270` |
| `2-presentation-open4-stove_build.json` | Cradle `stove_build`, target `.` | Cradle (open4) | `cca785b7c5386d56a574242670daa94d410c14c6f2799dbacbba5f5ec3336184` |
| `3-input-open4-stove_build.json` | Cradle `stove_build`, target `.` | Cradle (open4) | `b80936815aba83f0a949bf1fba5cbb7abd6c431f0718e32ccf7c8e34caa48b83` |
| `4-audio-open4-stove_build.json` | Cradle `stove_build`, target `.` | Cradle (open4) | `8ab21b3797bacc387f17b45ed63a84bffe18798da83bfc8c94b65f36f95e6a23` |
