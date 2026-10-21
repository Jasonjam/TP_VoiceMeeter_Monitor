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
    [DllImport("VoicemeeterRemote64.dll", CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Ansi)]
    public static extern int VBVMR_GetParameterFloat(string name, out float value);
}
'@
[VMRemote]::SetDllDirectory($dllDir) | Out-Null
$login = [VMRemote]::VBVMR_Login()
Write-Host "Login result: $login"
if ($login -ge 0) {
    foreach ($name in @('Strip[0].Gain', 'Bus[0].Gain')) {
        $value = [float]0
        $result = [VMRemote]::VBVMR_GetParameterFloat($name, [ref]$value)
        Write-Host "$name : result=$result gain=$value"
    }
    [VMRemote]::VBVMR_Logout() | Out-Null
}
