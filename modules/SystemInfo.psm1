function Get-GhostSystemInfo {
    [CmdletBinding()]
    param()

    $windowsKey = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
    if (-not (Test-Path $windowsKey)) {
        throw 'Ghost Toolbox currently supports Windows only.'
    }

    $os = Get-ItemProperty -Path $windowsKey
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    $isAdministrator = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    [pscustomobject]@{
        ProductName     = $os.ProductName
        DisplayVersion = $os.DisplayVersion
        EditionId      = $os.EditionID
        Build           = '{0}.{1}' -f $os.CurrentBuildNumber, $os.UBR
        Architecture    = $env:PROCESSOR_ARCHITECTURE
        IsAdministrator = $isAdministrator
        TimeZone        = [TimeZoneInfo]::Local.DisplayName
    }
}

Export-ModuleMember -Function Get-GhostSystemInfo
