Param(
    [ValidateNotNullOrEmpty()]
    [string]$Repository
)

if (-Not (Test-Path $Repository))
{
    Write-Host -ForegroundColor Red "*** $Repository does not exist"
    Exit 1
}

$buildDir=$PSScriptRoot
$nugetPackagesDir=[System.IO.Path]::Combine($buildDir, "packages")
$buildReportsDir=[System.IO.Path]::Combine($buildDir, "reports")
$fakeDir=[System.IO.Path]::Combine($buildDir, "fake")
$fakeDotDir=[System.IO.Path]::Combine($buildDir, ".fake")
$buildLock = [System.IO.Path]::Combine($buildDir, "build.fsx.lock")

Write-Host -ForegroundColor Red "*** Purging $Repository"

Get-ChildItem -Path $Repository -Filter 'bin' -Directory -Recurse | ForEach-Object { $_.Delete($true) }
Get-ChildItem -Path $Repository -Filter 'obj' -Directory -Recurse | ForEach-Object { $_.Delete($true) }
Get-ChildItem -Path $Repository -Filter 'TestResults' -Directory -Recurse | ForEach-Object { $_.Delete($true) }

if (Test-Path $nugetPackagesDir)
{
    Remove-Item -Path $nugetPackagesDir -Recurse -Force
}

if (Test-Path $buildReportsDir)
{
    Remove-Item -Path $buildReportsDir -Recurse -Force
}

if (Test-Path $fakeDir)
{
    Remove-Item -Path $fakeDir -Recurse -Force
}

if (Test-Path $fakeDotDir)
{
    Remove-Item -Path $fakeDotDir -Recurse -Force
}

if (Test-Path $buildLock)
{
    Remove-Item -Path $buildLock -Recurse -Force
}
