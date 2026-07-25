# Reference material

The repository history contains the legacy 1.9.0 files and
`Ghost Toolbox 1.9.1.17.zip` in commit
`062f6234b69b506567f76c7aac8914f9e49764f1`. The archive is intentionally not
duplicated in the current tree: it contains opaque executables and is used only
as migration reference.

Run the inventory tool from the repository root to inspect it without executing
or extracting any archive member:

```bash
python3 tools/inventory_reference.py
```

The reference is not a trusted software dependency. Files and URLs found in it
must be audited before any behavior is reimplemented.
