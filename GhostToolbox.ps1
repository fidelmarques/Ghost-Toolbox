[CmdletBinding()]
param(
    [ValidateSet('Menu', 'SystemInfo', 'ListPackages', 'Doctor')]
    [string]$Command = 'Menu'
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
        Write-Host '3. Run environment checks'
        Write-Host '0. Exit'
        switch (Read-Host 'Select an option') {
            '1' { Get-GhostSystemInfo | Format-List; Read-Host 'Press Enter to continue' | Out-Null }
            '2' { Get-GhostPackage -ManifestPath (Join-Path $root 'manifests/packages.json') | Format-Table Id, Name, Source; Read-Host 'Press Enter to continue' | Out-Null }
            '3' { Test-GhostEnvironment -RootPath $root | Format-Table Check, Status, Detail -AutoSize; Read-Host 'Press Enter to continue' | Out-Null }
            '0' { return }
            default { Write-Warning 'Invalid option.'; Start-Sleep -Seconds 1 }
        }
    }
}

switch ($Command) {
    'SystemInfo' { Get-GhostSystemInfo }
    'ListPackages' { Get-GhostPackage -ManifestPath (Join-Path $root 'manifests/packages.json') }
    'Doctor' { Test-GhostEnvironment -RootPath $root }
    'Menu' { Show-MainMenu }
}
