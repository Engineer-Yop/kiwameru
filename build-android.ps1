# Builds installable Android APKs for each app in docs/ using Capacitor.
# Usage (PowerShell):  powershell -ExecutionPolicy Bypass -File .\build-android.ps1
# Output: build\<app>.apk
$ErrorActionPreference = 'Continue'
$root = $PSScriptRoot
$jdk = Get-ChildItem "$root\build\jdk" -Directory | Select-Object -First 1
$env:JAVA_HOME = $jdk.FullName
$env:Path = "$env:JAVA_HOME\bin;$env:Path"
$env:ANDROID_HOME = "$env:LOCALAPPDATA\Android\Sdk"
$env:ANDROID_SDK_ROOT = $env:ANDROID_HOME
java -version 2>&1 | Select-Object -First 1

$apps = @(
  @{ id = 'opsdojo';  name = 'OpsDojo' },
  @{ id = 'devquest'; name = 'DevQuest' }
)

foreach ($a in $apps) {
  Write-Output "=== $($a.name) ==="
  $d = Join-Path $root "build\$($a.id)"
  New-Item -ItemType Directory -Force $d | Out-Null
  Set-Location $d

  if (-not (Test-Path package.json)) {
    npm.cmd init -y | Out-Null
    npm.cmd install --no-fund --no-audit @capacitor/core@7 @capacitor/cli@7 @capacitor/android@7
  }
  if (Test-Path www) { Remove-Item -Recurse -Force www }
  Copy-Item -Recurse (Join-Path $root "docs\$($a.id)") www

  if (-not (Test-Path capacitor.config.json)) {
    npx.cmd cap init $a.name "io.github.engineeryop.$($a.id)" --web-dir www
  }
  if (-not (Test-Path android)) { npx.cmd cap add android }
  npx.cmd cap sync android

  # App icon (best effort)
  New-Item -ItemType Directory -Force assets | Out-Null
  Copy-Item www\icon-1024.png assets\icon-only.png -Force
  Copy-Item www\icon-1024.png assets\icon-foreground.png -Force
  Copy-Item www\icon-1024.png assets\icon-background.png -Force
  npx.cmd --yes @capacitor/assets@3 generate --android --iconBackgroundColor '#0f1720' --splashBackgroundColor '#0f1720'

  Set-Location android
  .\gradlew.bat assembleDebug --no-daemon -q
  if ($LASTEXITCODE -eq 0) {
    Copy-Item app\build\outputs\apk\debug\app-debug.apk (Join-Path $root "build\$($a.id).apk") -Force
    Write-Output "BUILT build\$($a.id).apk"
  } else {
    Write-Output "FAILED $($a.id) (gradle exit $LASTEXITCODE)"
  }
  Set-Location $root
}
Write-Output "ALL_DONE"
