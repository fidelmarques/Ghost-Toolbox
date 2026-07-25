# Ghost-Toolbox 🛠️

An auditable community port of Ghost Toolbox for standard Windows installations.

> [!IMPORTANT]
> The legacy 1.9.0 script and its unsigned `nhcolor.exe` binary were removed
> from the downloadable source tree. They remain in Git history for research,
> but are not shipped or executed by the community port.

## Community port (early MVP)

The new entry point is `GhostToolbox.ps1`. It provides read-only system
information, curated package discovery, environment diagnostics, and confirmed
package installation through `winget`. It never executes the legacy script.

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\GhostToolbox.ps1
```

Non-interactive commands are also available:

```powershell
.\GhostToolbox.ps1 -Command SystemInfo
.\GhostToolbox.ps1 -Command ListPackages
.\GhostToolbox.ps1 -Command Doctor
```

From **Command Prompt (`cmd.exe`)**, use the launcher instead. Running a `.ps1`
path directly in Command Prompt can open the file association (often Notepad)
instead of invoking PowerShell. The launcher uses `-ExecutionPolicy Bypass`
only for the new PowerShell child process; it does not change the user or
machine execution policy:

```bat
GhostToolbox.cmd -Command Doctor
GhostToolbox.cmd -Command InstallPackage -PackageId firefox
```

From an existing **PowerShell** terminal, package installation can be started
directly after allowing scripts for the current process. This setting disappears
when that PowerShell window is closed:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\GhostToolbox.ps1 -Command InstallPackage -PackageId firefox
```

If an organization enforces execution policy through Group Policy, the
process-only override may be rejected. In that case, do not weaken the managed
policy; ask the administrator to review and approve/sign the script.

For deliberate unattended use, `-AcceptChanges` skips the Toolbox confirmation;
`winget` still uses an exact package ID and the `winget` source:

```powershell
.\GhostToolbox.ps1 -Command InstallPackage -PackageId firefox -AcceptChanges
```

Package metadata uses stable `winget` identifiers. Installations use explicit
confirmation, JSON Lines logs under `logs/`, exit-code handling, and a
post-install `winget list` verification.

See [`reference/README.md`](reference/README.md) for the reproducible inventory
of the 1.9.1.17 historical reference and [`docs/MIGRATION.md`](docs/MIGRATION.md)
for the safety gates and implementation roadmap.

## Security and antivirus reports

Do not disable browser or antivirus protection to download this project. The
current source tree intentionally contains no `.exe`, `.dll`, `.sys`, or `.msi`
files. If a release archive contains one of those file types, do not run it and
report the release name and detected file.

The historical scripts contained activation commands, certificate validation
bypasses, and downloads of privileged executables from mutable third-party
locations. Those behaviors are not part of this port. Package installation is
delegated to the installed Windows Package Manager using curated exact IDs.
