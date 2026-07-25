$root = Split-Path -Parent $PSScriptRoot
$module = Join-Path $root 'modules/Packages.psm1'
$manifest = Join-Path $root 'manifests/packages.json'

Describe 'Packages module' {
    BeforeAll {
        Import-Module $module -Force
    }

    It 'loads the curated package manifest' {
        $packages = @(Get-GhostPackage -ManifestPath $manifest)
        $packages.Count | Should -Be 3
        $packages.Id | Should -Contain 'firefox'
        ($packages | Where-Object Id -EQ 'firefox').WingetId | Should -Be 'Mozilla.Firefox'
    }

    It 'rejects an unknown package before invoking winget' {
        {
            Install-GhostPackage -ManifestPath $manifest -PackageId 'not-curated' -LogDirectory $TestDrive -AcceptChanges
        } | Should -Throw 'Unknown package ID*'
    }

    It 'rejects a missing manifest' {
        { Get-GhostPackage -ManifestPath (Join-Path $TestDrive 'missing.json') } | Should -Throw 'Package manifest not found*'
    }
}
