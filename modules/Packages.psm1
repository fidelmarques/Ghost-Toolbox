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

Export-ModuleMember -Function Get-GhostPackage
