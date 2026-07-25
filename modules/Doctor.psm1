function Test-GhostEnvironment {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$RootPath
    )

    $isWindowsHost = $PSVersionTable.PSVersion.Major -le 5 -or $IsWindows
    $checks = @(
        [pscustomobject]@{
            Check = 'Windows host'
            Status = if ($isWindowsHost) { 'Pass' } else { 'Fail' }
            Detail = if ($isWindowsHost) { 'Supported host detected.' } else { 'This port only changes Windows.' }
        }
        [pscustomobject]@{
            Check = 'PowerShell'
            Status = if ($PSVersionTable.PSVersion.Major -ge 5) { 'Pass' } else { 'Fail' }
            Detail = $PSVersionTable.PSVersion.ToString()
        }
        [pscustomobject]@{
            Check = 'Package manifest'
            Status = if (Test-Path (Join-Path $RootPath 'manifests/packages.json')) { 'Pass' } else { 'Fail' }
            Detail = Join-Path $RootPath 'manifests/packages.json'
        }
        [pscustomobject]@{
            Check = 'winget'
            Status = if (Get-Command winget.exe -ErrorAction SilentlyContinue) { 'Pass' } else { 'Warning' }
            Detail = 'Required for package installation commands.'
        }
    )
    $checks
}

Export-ModuleMember -Function Test-GhostEnvironment
