[CmdletBinding()]
param(
    [ValidateSet('Menu', 'SystemInfo', 'ListPackages', 'InstallPackage', 'Doctor')]
    [string]$Command = 'Menu',

    [string]$PackageId,

    [switch]$AcceptChanges
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$root = $PSScriptRoot
Import-Module (Join-Path $root 'modules/SystemInfo.psm1') -Force
Import-Module (Join-Path $root 'modules/Packages.psm1') -Force
Import-Module (Join-Path $root 'modules/Doctor.psm1') -Force

function Show-MainMenu {
    while ($true) {
        Clear-Host
        Write-Host 'Ghost Toolbox (community port)' -ForegroundColor Cyan
        Write-Host '1. System information'
        Write-Host '2. List curated packages'
        Write-Host '3. Install a curated package'
        Write-Host '4. Run environment checks'
        Write-Host '0. Exit'
        switch (Read-Host 'Select an option') {
            '1' { Get-GhostSystemInfo | Format-List; Read-Host 'Press Enter to continue' | Out-Null }
            '2' { Get-GhostPackage -ManifestPath (Join-Path $root 'manifests/packages.json') | Format-Table Id, Name, Source; Read-Host 'Press Enter to continue' | Out-Null }
            '3' {
                Get-GhostPackage -ManifestPath (Join-Path $root 'manifests/packages.json') | Format-Table Id, Name
                $selectedPackage = Read-Host 'Type the package ID'
                Install-GhostPackage -ManifestPath (Join-Path $root 'manifests/packages.json') -PackageId $selectedPackage -LogDirectory (Join-Path $root 'logs') | Format-List
                Read-Host 'Press Enter to continue' | Out-Null
            }
            '4' { Test-GhostEnvironment -RootPath $root | Format-Table Check, Status, Detail -AutoSize; Read-Host 'Press Enter to continue' | Out-Null }
            '0' { return }
            default { Write-Warning 'Invalid option.'; Start-Sleep -Seconds 1 }
        }
    }
}

switch ($Command) {
    'SystemInfo' { Get-GhostSystemInfo }
    'ListPackages' { Get-GhostPackage -ManifestPath (Join-Path $root 'manifests/packages.json') }
    'InstallPackage' {
        if ([string]::IsNullOrWhiteSpace($PackageId)) {
            throw '-PackageId is required when -Command InstallPackage is used.'
        }
        Install-GhostPackage -ManifestPath (Join-Path $root 'manifests/packages.json') -PackageId $PackageId -LogDirectory (Join-Path $root 'logs') -AcceptChanges:$AcceptChanges
    }
    'Doctor' { Test-GhostEnvironment -RootPath $root }
    'Menu' { Show-MainMenu }
}
