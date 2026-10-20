param(
    [Parameter(Mandatory = $true)][string]$BuildPath,
    [string]$VideoPath = "$PSScriptRoot/../test/samples/awakening.mp4"
)
$ErrorActionPreference = 'Stop'
$build = (Resolve-Path -LiteralPath $BuildPath).Path
$video = (Resolve-Path -LiteralPath $VideoPath).Path
$binary = Join-Path $build 'vlc.exe'
if (!(Test-Path -LiteralPath $binary)) { throw 'The Windows executable is missing.' }
$output = Join-Path $build 'validation'
New-Item -ItemType Directory -Force -Path $output | Out-Null
$log = Join-Path $output 'startup.log'
$arguments = @(
    '--intf=qt', '--ignore-config', '--no-qt-privacy-ask',
    '--no-metadata-network-access', '--no-media-library', '--no-loop', '--no-repeat',
    '--no-one-instance', '--no-one-instance-when-started-from-file',
    '--no-qt-video-autoresize', '--play-and-exit', '--no-audio',
    '--file-logging', '--logmode=text', '--verbose=2',
    ('--logfile="' + $log + '"'), ('"' + $video + '"'), 'vlc://quit'
)
$player = Start-Process -FilePath $binary -ArgumentList $arguments -WorkingDirectory $build -PassThru
$null = $player.Handle
$deadline = [DateTime]::UtcNow.AddSeconds(45)
while (!$player.HasExited -and [DateTime]::UtcNow -lt $deadline) {
    Start-Sleep -Milliseconds 250
    $player.Refresh()
}
$timedOut = !$player.HasExited
if ($timedOut) { Stop-Process -Id $player.Id -ErrorAction SilentlyContinue }
$content = Get-Content -LiteralPath $log -Raw
$failures = $content -split "`r?`n" | Where-Object {
    $_ -match 'cannot load plug-in|qrc:.*(Error|is not a type|is unavailable|Cannot assign)|QQmlApplicationEngine failed'
}
if ($failures) {
    $failures | Write-Output
    throw 'The player reported a plugin or QML startup failure.'
}
if ($timedOut) { throw 'The playback smoke test did not exit within 45 seconds.' }
if ($player.ExitCode -ne 0) { throw "The player exited with code $($player.ExitCode)." }
if ($content -notmatch 'Received first picture') { throw 'No decoded video frame reached the video output.' }
Write-Output 'Passed: native Qt startup, plugin loading, first video frame, and playback exit.'
