$ErrorActionPreference = 'Stop'
$dllDir = 'C:\Program Files (x86)\VB\Voicemeeter'
Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public static class VMRemote {
    [DllImport("kernel32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
    public static extern bool SetDllDirectory(string path);
    [DllImport("VoicemeeterRemote64.dll", CallingConvention = CallingConvention.StdCall)]
    public static extern int VBVMR_Login();
    [DllImport("VoicemeeterRemote64.dll", CallingConvention = CallingConvention.StdCall)]
    public static extern int VBVMR_Logout();
    [DllImport("VoicemeeterRemote64.dll", CallingConvention = CallingConvention.StdCall)]
    public static extern int VBVMR_GetVoicemeeterType(out int type);
    [DllImport("VoicemeeterRemote64.dll", CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Ansi)]
    public static extern int VBVMR_GetParameterFloat(string name, out float value);
}
'@
[VMRemote]::SetDllDirectory($dllDir) | Out-Null
$login = [VMRemote]::VBVMR_Login()
Write-Host "Login result: $login"
if ($login -ge 0) {
    $type = 0
    $typeResult = [VMRemote]::VBVMR_GetVoicemeeterType([ref]$type)
    Write-Host "Type result: $typeResult, Voicemeeter type: $type"
    $stripCount = 0
    $busCount = 0
    if ($type -eq 1) { $stripCount = 2; $busCount = 2 }
    if ($type -eq 2) { $stripCount = 5; $busCount = 5 }
    if ($type -eq 3) { $stripCount = 8; $busCount = 8 }
    Write-Host "Expected Strip: $stripCount, Bus: $busCount"
    $names = @()
    for ($i = 0; $i -lt $stripCount; $i++) { $names += "Strip[$i].Gain" }
    for ($i = 0; $i -lt $busCount; $i++) { $names += "Bus[$i].Gain" }
    foreach ($name in $names) {
        $value = [float]0
        $result = [VMRemote]::VBVMR_GetParameterFloat($name, [ref]$value)
        Write-Host "$name : result=$result gain=$value"
    }
    [VMRemote]::VBVMR_Logout() | Out-Null
}
