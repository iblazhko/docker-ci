Param(
    [ValidateNotNullOrEmpty()]
    [string]$Target="FullBuild",

    [ValidateNotNullOrEmpty()]
    [ValidateSet("Debug", "Release")]
    [string]$Configuration="Release",

    [ValidateNotNullOrEmpty()]
    [ValidateSet("any", "win-x64", "linux-x64", "linux-arm")]
    [string]$Runtime="linux-x64"
)

$buildDir=$PSScriptRoot
$repositoryDir=(Get-Item $buildDir).Parent.FullName
$fakeDir=[System.IO.Path]::Combine($buildDir, "fake")
$fake=[System.IO.Path]::Combine($fakeDir, "fake")
$buildScript=[System.IO.Path]::Combine($buildDir, "build.fsx")

$requiredDotnetVersion = "2.1"

# Purge target requires special treatment
if ($Target -eq "Purge")
{
    & "$buildDir/purge.ps1" -Repository "$repositoryDir"
    Exit $LASTEXITCODE
}

# Check if .NET CLI is available
try
{
    [System.Version]$dotnetVersion = dotnet --version
    [System.Version]$minSupportedDotnetVersion = $requiredDotnetVersion

    if (-Not($dotnetVersion -ge $minSupportedDotnetVersion))
    {
        Write-Host -ForegroundColor Red "*** Required 'dotnet' version $requiredDotnetVersion or higher. Install .NET Core SDK from https://www.microsoft.com/net/download"
        Exit 1
    }
}
catch
{
    Write-Host -ForegroundColor Red "*** 'dotnet' is not available. Install .NET Core from https://www.microsoft.com/net/download"
    Exit 1
}

# Make sure FAKE CLI is available
if (-Not (Test-Path "$fake.*"))
{
    Write-Host -ForegroundColor Green "***    Installing FAKE CLI"
    & dotnet tool install fake-cli --tool-path "$fakeDir"
    if ($LASTEXITCODE -ne 0)
    {
        Exit $LASTEXITCODE
    }
}

# Ready to start the build
Write-Host -ForegroundColor Green ""
Write-Host -ForegroundColor Green "*** FAKE it: target $Target ($Configuration) in $repositoryDir"

# Set build configuration settings via environment variables
[Environment]::SetEnvironmentVariable("Build_RepositoryDir", $repositoryDir, "Process")
[Environment]::SetEnvironmentVariable("Build_Configuration", $Configuration, "Process")
[Environment]::SetEnvironmentVariable("Build_Runtime", $Runtime, "Process")
[Environment]::SetEnvironmentVariable("FAKE_ALLOW_NO_DEPENDENCIES", "true", "Process")

& "$fake" run "$buildScript" --target "$Target"
Exit $LASTEXITCODE
