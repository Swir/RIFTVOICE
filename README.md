# RIFTVOICE 0.3.0 — by Swir 🎙️

**Native gaming voice changer for Windows 11 x64.** Designed for Steam and Counter-Strike 2 voice chat, without modifying CS2 or injecting any DLLs.

### Download the complete offline package

[**Releases — RiftVoice 0.3.0 Windows 11 x64**](https://github.com/Swir/RIFTVOICE/releases)

The ZIP includes the standalone `RiftVoice.exe` **and the unchanged official VB-Audio VB-CABLE installer**, so players do not need to install Python, Go, .NET or search for a driver download.

1. Extract the **entire ZIP** to a folder.
2. Run `START_TUTAJ.cmd`. If the virtual microphone is missing, the included driver installer is offered with explicit confirmation; Windows will ask for administrator/UAC permission.
3. Restart Windows **only if the VB-Audio driver requires it** (RiftVoice will not restart your PC).
4. In RiftVoice select your microphone and **CABLE Input**, then click **START LIVE**.
5. In Steam / Counter-Strike 2 select **CABLE Output** as microphone. Keep game audio on your headphones, not on the cable.

### Features

- 9 presets: Natural, Deep Bass, Demon, Robot, Alien, Chipmunk, Radio, Megaphone, Narrator.
- Live pitch, mix, mic gain, noise gate, MUTE, BYPASS and meter controls.
- Six original synthesized soundboard cues.
- Portable Win32 GUI, x64; native Go/WinMM processing without runtime dependencies.
- Outgoing audio is restricted to the virtual cable to reduce accidental audio feedback.
- No game hooks, automatic Windows default audio changes or automatic reboots.

### Verification status

Go DSP tests and the Windows x64 compilation are checked in the CI workflow. **Full end-to-end microphone, VB-CABLE, Steam and CS2 gameplay verification on physical Windows 11 hardware is still pending**; do not equate passing unit tests with verified stability or zero latency.

### Legal notes

VB-CABLE is a separate donationware driver by **VB-Audio**, from **www.vb-cable.com**. Donations are welcome; business use may require a license. The original ZIP is bundled unmodified in line with the [VB-Audio distribution terms](https://vb-audio.com/Services/licensing.htm). RiftVoice and VB-CABLE have different publishers.

### Source and CI

Go source files and tests are extracted from the archive in `distribution/` with the versioned upgrade patch. The [release workflow](.github/workflows/build-release.yml) builds on a Windows runner, runs tests, fetches the official vendor ZIP, and publishes an all-in-one release only when packaging succeeds. Go is needed only by developers rebuilding the executable.

**by Swir** — [GitHub profile](https://github.com/Swir)
