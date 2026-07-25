# Ghost-Toolbox 🛠️

An auditable community port of Ghost Toolbox for standard Windows installations.

> [!WARNING]
> The legacy 1.9.0 script is retained for research and is not the supported
> entry point. It contains obsolete downloads and privileged system changes.

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
instead of invoking PowerShell:

```bat
GhostToolbox.cmd -Command Doctor
GhostToolbox.cmd -Command InstallPackage -PackageId firefox
```

From an existing **PowerShell** terminal, package installation can be started
directly. It displays the exact `winget` command and asks for confirmation:

```powershell
.\GhostToolbox.ps1 -Command InstallPackage -PackageId firefox
```

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

## Legacy 1.9.0 instructions

The instructions below describe the archived upstream script and are retained
for historical context only.

## Quick Setup Guide 📋

### Step 1: Download
- Go to the **Releases** section and download the Ghost Toolbox folder
- Extract it to your desired location

### Step 2: Install Color Support
- Find the file called `nhcolor.exe` in the downloaded folder
- Copy this file to your `C:\Windows\System32` folder
- *(This file enables colorful text and verifies Ghost Spectre OS compatibility)*

### Step 3: Run the Toolbox
- Right-click on `Ghost Toolbox.cmd` 
- Select **"Run as Administrator"**
- That's it! 🎉

## Important Notes ⚠️
- The `update.cmd` file is **not included** in this version
- You **must** run as Administrator for the toolbox to work properly
- This tool works on any Windows OS, not just Ghost Spectre

---

**Disclaimer:** This project is **NOT MADE BY ME** - I'm just sharing an improved version for easier use!

### Preview
![Ghost Toolbox Screenshot](https://github.com/Batlez/Ghost-Toolbox/assets/116146426/ba477e31-8680-4aa6-8456-f652cb5d6b5c)

---
