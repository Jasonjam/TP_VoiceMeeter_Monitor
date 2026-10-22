# TP VoiceMeeter Monitor

[English](README.md) | [繁體中文](docs/README.zh-TW.md)

A read-only Touch Portal plugin for displaying Voicemeeter Gain values.

Supports Voicemeeter Standard, Banana, and Potato with automatic edition detection. This plugin only reads and displays Gain values; it does not control Voicemeeter.

## Download & Installation

Download `TP_VoiceMeeter_Monitor.tpp` from [GitHub Releases](https://github.com/Jasonjam/TP_VoiceMeeter_Monitor/releases) and import it into Touch Portal.

Use the plugin's States to display Gain values on your Touch Portal buttons.

## States

- Strip 0–7: `vm_strip_0_gain` through `vm_strip_7_gain`
- Bus 0–7: `vm_bus_0_gain` through `vm_bus_7_gain`

The plugin detects the running Voicemeeter edition and only reads available Strip and Bus channels. It polls Gain values every 500 ms and updates Touch Portal States when values change.

## Build

Run the following command in PowerShell on Windows:

```powershell
.\build.ps1
```

Output: `dist/TP_VoiceMeeter_Monitor.tpp`

## Release

After merging changes into `main`, create and push a version tag (for example, `v0.1.0`). GitHub Actions automatically builds the plugin, creates a GitHub Release, and attaches the `.tpp` file as a downloadable asset.

## Project Structure

- `src/`: Touch Portal plugin source files
- `tests/`: Voicemeeter API diagnostic script
- `build.ps1`: PowerShell packaging script
- `dist/`: Build output (ignored by Git)

## Compatibility

- Touch Portal v3.1 Build 12: tested
- Voicemeeter Banana: tested
- Voicemeeter Standard / Potato: implemented, not yet tested on those editions
