$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$source = Join-Path $root 'src'
$dist = Join-Path $root 'dist'
$staging = Join-Path ([System.IO.Path]::GetTempPath()) ('vm-monitor-' + [guid]::NewGuid().ToString('N'))
$plugin = Join-Path $staging 'VoicemeeterMonitor'
$output = Join-Path $dist 'TP_VoiceMeeter_Monitor.tpp'
$zip = Join-Path $dist 'TP_VoiceMeeter_Monitor.zip'

try {
    New-Item -ItemType Directory -Force -Path $plugin, $dist | Out-Null
    foreach ($name in @('entry.tp', 'index.js', 'voicemeeter.ps1')) {
        $file = Join-Path $source $name
        if (-not (Test-Path $file -PathType Leaf)) { throw "Missing source file: $file" }
        Copy-Item $file -Destination $plugin
    }

    $entry = Get-Content (Join-Path $plugin 'entry.tp') -Raw | ConvertFrom-Json
    if ($entry.plugin_start_cmd -ne 'node %TP_PLUGIN_FOLDER%VoicemeeterMonitor/index.js') {
        throw 'Unexpected plugin_start_cmd'
    }

    if (Test-Path $zip) { Remove-Item $zip -Force }
    Compress-Archive -Path $plugin -DestinationPath $zip -Force
    Move-Item $zip $output -Force
    Write-Host "Built: $output"
}
finally {
    if (Test-Path $staging) { Remove-Item $staging -Recurse -Force }
}
