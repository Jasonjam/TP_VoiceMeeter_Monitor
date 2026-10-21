# TP VoiceMeeter Monitor

Read-only Touch Portal plugin that displays Voicemeeter Gain values. Supports Voicemeeter Standard, Banana and Potato (detected automatically).

## Download

Download `TP_VoiceMeeter_Monitor.tpp` from [GitHub Releases](https://github.com/Jasonjam/TP_VoiceMeeter_Monitor/releases), then import it into Touch Portal.

## States

- Strip 0–7: `vm_strip_0_gain` through `vm_strip_7_gain`
- Bus 0–7: `vm_bus_0_gain` through `vm_bus_7_gain`

Only channels available in the running Voicemeeter edition are polled. Gain is read every 500 ms. The plugin does not control Voicemeeter.

## Build

On Windows with PowerShell:

```powershell
./build.ps1
```

Output: `dist/TP_VoiceMeeter_Monitor.tpp`

## Release

After merging the changes into `main`, push a version tag (for example `v0.1.0`) to trigger GitHub Actions. The workflow builds the plugin and attaches the TPP file to a GitHub Release.

## Development

- `src/`: Touch Portal plugin files
- `tests/`: diagnostic script
- `build.ps1`: package builder
- `dist/`: ignored build artifacts
