# TP VoiceMeeter Monitor

[English](../README.md) | [繁體中文](README.zh-TW.md)

一款唯讀的 Touch Portal 插件，用於顯示 Voicemeeter 的 Gain（增益）數值。

支援 Voicemeeter Standard、Banana、Potato，並自動偵測目前使用的版本。本插件只負責讀取與顯示數值，不會控制或修改 Voicemeeter。

## 下載與安裝

前往 [GitHub Releases](https://github.com/Jasonjam/TP_VoiceMeeter_Monitor/releases) 下載 `TP_VoiceMeeter_Monitor.tpp`，再將檔案匯入 Touch Portal。

匯入後，即可使用插件提供的 States，在 Touch Portal 按鈕上顯示 Gain 數值。

## States

- Strip 0–7：`vm_strip_0_gain` 至 `vm_strip_7_gain`
- Bus 0–7：`vm_bus_0_gain` 至 `vm_bus_7_gain`

插件會依照目前執行的 Voicemeeter 版本，自動判斷可讀取的 Strip 與 Bus 數量。每 500ms 讀取一次 Gain，並在數值變化時更新 Touch Portal State。

## Build

在 Windows 的 PowerShell 執行：

```powershell
.\build.ps1
```

輸出檔案：`dist/TP_VoiceMeeter_Monitor.tpp`

## Release

將修改合併至 `main` 後，建立並推送版本 Tag（例如 `v0.1.0`）。GitHub Actions 會自動打包插件、建立 GitHub Release，並將 `.tpp` 安裝檔附加至 Release Assets，供使用者下載。

## 專案結構

- `src/`：Touch Portal 插件原始碼
- `tests/`：Voicemeeter API 測試腳本
- `build.ps1`：PowerShell 自動打包腳本
- `dist/`：打包產物（不納入 Git 版本控制）

## 相容性

- Touch Portal v3.1 Build 12：已測試
- Voicemeeter Banana：已測試
- Voicemeeter Standard / Potato：已實作支援，尚未實機測試
