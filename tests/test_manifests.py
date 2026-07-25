import json
import pathlib
import unittest


ROOT = pathlib.Path(__file__).resolve().parents[1]


class ManifestTests(unittest.TestCase):
    def test_package_ids_are_unique_and_complete(self):
        manifest = json.loads((ROOT / "manifests/packages.json").read_text())
        self.assertEqual(manifest["SchemaVersion"], 1)
        ids = [package["Id"] for package in manifest["Packages"]]
        self.assertEqual(len(ids), len(set(ids)))
        for package in manifest["Packages"]:
            self.assertTrue(package["Name"])
            self.assertTrue(package["WingetId"])

    def test_unknown_builds_block_mutations(self):
        manifest = json.loads((ROOT / "manifests/compatibility.json").read_text())
        self.assertEqual(manifest["SchemaVersion"], 1)
        self.assertEqual(manifest["Policy"]["UnknownBuild"], "BlockMutatingActions")
        self.assertEqual(manifest["ValidatedBuilds"], [])


if __name__ == "__main__":
    unittest.main()
