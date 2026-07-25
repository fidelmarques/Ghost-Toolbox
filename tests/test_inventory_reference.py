import json
import pathlib
import subprocess
import unittest


ROOT = pathlib.Path(__file__).resolve().parents[1]


class ReferenceInventoryTests(unittest.TestCase):
    def test_historical_reference_is_reproducible(self):
        output = subprocess.run(
            ["python3", "tools/inventory_reference.py"],
            cwd=ROOT,
            check=True,
            text=True,
            stdout=subprocess.PIPE,
        ).stdout
        inventory = json.loads(output)
        self.assertEqual(inventory["archive"]["members"], 103)
        self.assertEqual(inventory["script"]["lines"], 28714)
        self.assertEqual(inventory["script"]["sha256"], "dca55cdac87cea9252d3b4de68aab165b090f65f788413bce413bbd66bf8da65")


if __name__ == "__main__":
    unittest.main()
