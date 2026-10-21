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
    [DllImport("VoicemeeterRemote64.dll", CallingConvention = CallingConvention.StdCall)]
    public static extern int VBVMR_GetVoicemeeterType(out int type);
    [DllImport("VoicemeeterRemote64.dll", CallingConvention = CallingConvention.StdCall)]
    public static extern int VBVMR_IsParametersDirty();
    [DllImport("VoicemeeterRemote64.dll", CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Ansi)]
    public static extern int VBVMR_GetParameterFloat(string name, out float value);
}
'@
[VMRemote]::SetDllDirectory($dllDir) | Out-Null
$login = [VMRemote]::VBVMR_Login()
if ($login -lt 0) { throw "Voicemeeter login failed: $login" }
try {
    $vmType = 0
    $typeResult = [VMRemote]::VBVMR_GetVoicemeeterType([ref]$vmType)
    if ($typeResult -ne 0) { throw "Voicemeeter type detection failed: $typeResult" }
    $stripCount = 0
    $busCount = 0
    if ($vmType -eq 1) { $stripCount = 2; $busCount = 2 }
    if ($vmType -eq 2) { $stripCount = 5; $busCount = 5 }
    if ($vmType -eq 3) { $stripCount = 8; $busCount = 8 }
    if ($stripCount -eq 0) { throw "Unsupported Voicemeeter type: $vmType" }
    [Console]::Error.WriteLine("Voicemeeter type=$vmType, strips=$stripCount, buses=$busCount")
    while ($true) {
        $dirtyResult = [VMRemote]::VBVMR_IsParametersDirty()
        if ($dirtyResult -lt 0) { throw "Voicemeeter parameter sync failed: $dirtyResult" }
        $states = @{}
        foreach ($type in @('Strip', 'Bus')) {
            $count = $stripCount
            if ($type -eq 'Bus') { $count = $busCount }
            for ($i = 0; $i -lt $count; $i++) {
                $value = [float]0
                $result = [VMRemote]::VBVMR_GetParameterFloat("${type}[$i].Gain", [ref]$value)
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
