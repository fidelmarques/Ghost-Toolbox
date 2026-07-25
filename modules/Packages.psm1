function Get-GhostPackage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ManifestPath
    )

    if (-not (Test-Path -LiteralPath $ManifestPath -PathType Leaf)) {
        throw "Package manifest not found: $ManifestPath"
    }

    $manifest = Get-Content -LiteralPath $ManifestPath -Raw | ConvertFrom-Json
    if ($manifest.SchemaVersion -ne 1) {
        throw "Unsupported package manifest schema: $($manifest.SchemaVersion)"
    }

    foreach ($package in $manifest.Packages) {
        if ([string]::IsNullOrWhiteSpace($package.Id) -or [string]::IsNullOrWhiteSpace($package.WingetId)) {
            throw 'Every package must define Id and WingetId.'
        }
        [pscustomobject]@{
            Id       = $package.Id
            Name     = $package.Name
            WingetId = $package.WingetId
            Source   = 'winget'
        }
    }
}

function Write-GhostPackageLog {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string]$LogDirectory,
        [Parameter(Mandatory)] [hashtable]$Entry
    )

    New-Item -ItemType Directory -Path $LogDirectory -Force | Out-Null
    $logPath = Join-Path $LogDirectory ('ghost-toolbox-{0}.jsonl' -f (Get-Date -Format 'yyyyMMdd'))
    $Entry.Timestamp = [DateTime]::UtcNow.ToString('o')
    Add-Content -LiteralPath $logPath -Value ($Entry | ConvertTo-Json -Compress) -Encoding UTF8
    $logPath
}

function Install-GhostPackage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string]$ManifestPath,
        [Parameter(Mandatory)] [string]$PackageId,
        [Parameter(Mandatory)] [string]$LogDirectory,
        [switch]$AcceptChanges
    )

    $package = @(Get-GhostPackage -ManifestPath $ManifestPath | Where-Object Id -EQ $PackageId)
    if ($package.Count -ne 1) {
        throw "Unknown package ID: $PackageId"
    }

    $winget = Get-Command winget.exe -ErrorAction SilentlyContinue
    if (-not $winget) {
        throw 'winget.exe was not found. Install or repair Microsoft App Installer first.'
    }

    $installArguments = @(
        'install', '--exact', '--id', $package[0].WingetId, '--source', 'winget',
        '--accept-source-agreements', '--accept-package-agreements', '--disable-interactivity'
    )
    $displayCommand = 'winget.exe ' + (($installArguments | ForEach-Object {
        if ($_ -match '[\s"]') { '"{0}"' -f ($_ -replace '"', '\"') } else { $_ }
    }) -join ' ')

    if (-not $AcceptChanges) {
        $answer = Read-Host "Install $($package[0].Name) using '$displayCommand'? [y/N]"
        if ($answer -notin @('y', 'Y', 'yes', 'YES')) {
            return [pscustomobject]@{
                PackageId = $PackageId
                WingetId  = $package[0].WingetId
                Status    = 'Cancelled'
                ExitCode  = $null
                LogPath   = $null
            }
        }
    }

    & $winget.Source @installArguments
    $installExitCode = $LASTEXITCODE
    $verificationExitCode = $null
    if ($installExitCode -eq 0) {
        & $winget.Source 'list' '--exact' '--id' $package[0].WingetId '--source' 'winget' '--accept-source-agreements' '--disable-interactivity'
        $verificationExitCode = $LASTEXITCODE
    }
    $status = if ($installExitCode -eq 0 -and $verificationExitCode -eq 0) { 'Success' } else { 'Failed' }
    $logPath = Write-GhostPackageLog -LogDirectory $LogDirectory -Entry @{
        Operation = 'InstallPackage'
        PackageId = $PackageId
        WingetId  = $package[0].WingetId
        Command   = $displayCommand
        ExitCode  = $installExitCode
        VerificationExitCode = $verificationExitCode
        Status    = $status
    }

    $result = [pscustomobject]@{
        PackageId = $PackageId
        WingetId  = $package[0].WingetId
        Status    = $status
        ExitCode  = $installExitCode
        LogPath   = $logPath
    }
    if ($status -ne 'Success') {
        Write-Error "Package installation or verification failed. See $logPath"
    }
    $result
}

Export-ModuleMember -Function Get-GhostPackage, Install-GhostPackage
