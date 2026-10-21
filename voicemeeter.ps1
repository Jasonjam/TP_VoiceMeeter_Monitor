$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$dllDir = 'C:\Program Files (x86)\VB\Voicemeeter'
Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public static class VMRemote {
    [DllImport("kernel32.dll", CharSet = CharSet.Unicode)]
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
if ($login -lt 0) { throw "Voicemeeter login failed: $login" }
try {
    while ($true) {
        $states = @{}
        foreach ($type in @('Strip', 'Bus')) {
            $count = 8
            if ($type -eq 'Bus') { $count = 5 }
            for ($i = 0; $i -lt $count; $i++) {
                $value = [float]0
                $result = [VMRemote]::VBVMR_GetParameterFloat("$type[$i].Gain", [ref]$value)
                if ($result -eq 0) {
                    $states["vm_$($type.ToLower())_$($i)_gain"] = $value.ToString('F1', [System.Globalization.CultureInfo]::InvariantCulture)
                }
            }
        }
        [Console]::WriteLine(($states | ConvertTo-Json -Compress))
        Start-Sleep -Milliseconds 500
    }
}
finally {
    [VMRemote]::VBVMR_Logout() | Out-Null
}
