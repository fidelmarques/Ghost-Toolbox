import pathlib
import unittest


ROOT = pathlib.Path(__file__).resolve().parents[1]


class LauncherTests(unittest.TestCase):
    def test_cmd_launcher_uses_process_only_policy_override(self):
        launcher = (ROOT / "GhostToolbox.cmd").read_text().lower()
        invocation = next(
            line for line in launcher.splitlines() if line.startswith("powershell.exe ")
        )
        self.assertIn("-noprofile", invocation)
        self.assertIn("-executionpolicy bypass", invocation)
        self.assertIn('-file "%~dp0ghosttoolbox.ps1" %*', invocation)

    def test_launcher_does_not_persist_execution_policy(self):
        launcher = (ROOT / "GhostToolbox.cmd").read_text().lower()
        self.assertNotIn("set-executionpolicy", launcher)


if __name__ == "__main__":
    unittest.main()
