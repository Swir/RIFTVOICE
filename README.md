# RiftVoice — by Swir 🎙️

**RiftVoice 0.2.0** is a native Windows x64 real-time voice changer designed for gaming voice chat, including Steam and Counter-Strike 2 via a separate virtual audio cable.

> **Testing status:** The original local Windows x64 EXE was cross-compiled and the DSP unit tests passed (13/13). The actual microphone/audio driver/Steam/CS2 route has **not** been tested on a real Windows 11 machine yet. Treat this as an **experimental build**, not a fully verified gaming release.

## Features
- 9 voice presets (Natural, Deep Bass, Demon, Robot, Alien, Chipmunk, Radio, Megaphone, Narrator)
- Live voice processing, mic/output device selection, mute/bypass, meters, noise gate
- 6-button soundboard
- Native Win32 user interface; no Python, .NET or Node runtime
- Source code in Go, with DSP tests

## Installation and game setup
1. Download the portable Windows x64 ZIP **when it appears under Releases**. Extract it and launch `RiftVoice.exe`.
2. Install [VB-CABLE from the official vendor](https://vb-audio.com/Cable/index.htm) separately if you want to use RiftVoice as a microphone in games. We do not redistribute this third-party driver.
3. In RiftVoice choose your physical microphone as input and **CABLE Input** as output.
4. In Steam and CS2 select **CABLE Output** as microphone and test your voice in Steam before starting a competitive game.
5. Keep game sound routed to headphones, **not** the cable, to avoid feedback.

## Build locally
Requires Go 1.23+ on Windows x64.

```powershell
cd source
go test ./...
go build -ldflags="-H=windowsgui -s -w" -o ..\RiftVoice.exe .
```

Cross-compilation from Linux:

```bash
cd source
GOOS=windows GOARCH=amd64 CGO_ENABLED=0 go build -ldflags='-H=windowsgui -s -w' -o ../RiftVoice.exe .
```

The local source bundle and release packaging are being transferred into this repository. A compiled build is **not** evidence of in-game verification.

## Author
**by Swir** — [github.com/Swir](https://github.com/Swir)

*No DLL injection, game memory hooks, or modifications to CS2 files are required.*
