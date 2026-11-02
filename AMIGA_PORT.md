# Amiga port intake: Raptor: Call of the Shadows

- Port Atlas: [g-raptor-call-of-the-shadows](https://www.amicradle.com/ports/#g-raptor-call-of-the-shadows)
- Priority: `P2`
- Atlas decision: `port`
- Upstream source: `https://github.com/skynettx/raptor`
- Atlas source pin: `746c35a256bfa2afc6732c7923be9e2e777d6bf0`
- Imported commit: `746c35a256bfa2afc6732c7923be9e2e777d6bf0`
- Rights state: `review`

## Target contract

Primary target: AmigaOS 3.x / AmiCradle AC090 / Motorola 68040 + FPU.

Use the OPEN platform libraries where applicable: OpenGPU, OpenAudio/OpenAHI, OpenInput, OpenSocket and measured OpenMulticore work. Preserve a correct 68040 fallback and do not assume Roadshow.

The source-intake commit made no build or runtime claim. Since 2 November 2026 the port builds and runs in the lab at TESTING (README.md, *Status* and *Observed*); no release claim is made. Upstream submodules are not initialised. The game data stays external: `runtime-data/build-amiga.sh` fetches the shareware episode, pinned in `gameports/runtime-data.json`.

## Rights and data boundary

review; Confirm source/data licences before release.
