# Migration plan

## Principles

The community port treats the historical scripts as behavioral references, not
as trusted dependencies. New functionality must be readable, testable,
reversible where possible, and safe when Windows reports an unknown build.

The port will not include activation bypasses, remote scripts executed without
verification, certificate-check disabling, or binaries whose provenance and
license cannot be established.

## Delivery phases

1. **Foundation (current MVP):** system discovery, diagnostics, curated package
   metadata, reference inventory, and a non-destructive menu.
2. **Package management:** explicit confirmation and `winget`-backed installs
   from stable identifiers, with logs and exit-code handling.
3. **Windows features:** capability detection and reversible management of
   supported optional features.
4. **Maintenance:** narrowly scoped cleanup operations with previews and clear
   reporting.
5. **Tweaks:** individually documented registry or service changes, each with a
   compatibility rule and rollback implementation.

## Gate for mutating actions

Before a module may change the machine, it must provide:

- a description of the exact change and required privilege;
- a compatibility entry for validated Windows builds and editions;
- an interactive confirmation, with a separate explicit automation switch;
- structured logging without secrets;
- postcondition verification;
- rollback instructions or a documented reason rollback is impossible;
- official provenance and integrity verification for downloaded content.

`manifests/compatibility.json` deliberately starts with no validated builds.
Unknown and untested systems must remain able to use read-only commands, while
mutating actions stay blocked.

## Legacy mapping

The next inventory stage will map each visible option in `run.ghost.cmd` to its
labels, commands, remote resources, privilege level, and risk classification.
Only options that pass the gate above should become port modules.
