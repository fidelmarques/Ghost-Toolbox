import pathlib
import subprocess
import unittest


ROOT = pathlib.Path(__file__).resolve().parents[1]
FORBIDDEN_SUFFIXES = {".dll", ".exe", ".msi", ".sys"}
FORBIDDEN_LEGACY_MARKERS = (b"kms8.msguides.com", b"--no-check-certificate")


class DistributionSafetyTests(unittest.TestCase):
    def tracked_files(self):
        output = subprocess.run(
            ["git", "ls-files", "-z"],
            cwd=ROOT,
            check=True,
            stdout=subprocess.PIPE,
        ).stdout
        return [pathlib.Path(value.decode()) for value in output.split(b"\0") if value]

    def test_distribution_has_no_opaque_windows_binaries(self):
        forbidden = [
            str(path) for path in self.tracked_files()
            if path.suffix.lower() in FORBIDDEN_SUFFIXES
        ]
        self.assertEqual(forbidden, [])

    def test_current_tree_has_no_known_legacy_download_markers(self):
        findings = []
        for relative_path in self.tracked_files():
            content = (ROOT / relative_path).read_bytes().lower()
            for marker in FORBIDDEN_LEGACY_MARKERS:
                if marker in content and relative_path != pathlib.Path(__file__).relative_to(ROOT):
                    findings.append(f"{relative_path}: {marker.decode()}")
        self.assertEqual(findings, [])


if __name__ == "__main__":
    unittest.main()
