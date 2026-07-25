#!/usr/bin/env python3
"""Inventory the historical Ghost Toolbox archive without extracting it."""

from __future__ import annotations

import hashlib
import io
import json
import re
import subprocess
import zipfile

REFERENCE = "062f623:Ghost Toolbox 1.9.1.17.zip"
SCRIPT = "Ghost Toolbox/run.ghost.cmd"


def git_object(spec: str) -> bytes:
    return subprocess.run(
        ["git", "show", spec], check=True, stdout=subprocess.PIPE
    ).stdout


def main() -> None:
    archive = git_object(REFERENCE)
    with zipfile.ZipFile(io.BytesIO(archive)) as source:
        script = source.read(SCRIPT)
        text = script.decode("utf-8", errors="replace")
        result = {
            "archive": {
                "git_object": REFERENCE,
                "sha256": hashlib.sha256(archive).hexdigest(),
                "compressed_bytes": len(archive),
                "members": len(source.infolist()),
                "uncompressed_bytes": sum(item.file_size for item in source.infolist()),
            },
            "script": {
                "path": SCRIPT,
                "sha256": hashlib.sha256(script).hexdigest(),
                "bytes": len(script),
                "lines": len(text.splitlines()),
                "labels": len(set(re.findall(r"(?m)^:([^:\s]+)", text))),
                "urls": len(re.findall(r"https?://[^\s\"<>]+", text)),
            },
            "members": [
                {"path": item.filename, "bytes": item.file_size}
                for item in source.infolist()
                if not item.is_dir()
            ],
        }
    print(json.dumps(result, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
