"""
Redeclare a dependency on nanobind_bazel by overwriting the content of MODULE.bazel.

Used in nanobind-bazel CI to test against development versions in pull requests.
"""

import re
import sys
from pathlib import Path

# TODO: Support arbitrary paths in the template below
_LOCAL_NANOBIND_BAZEL = """
bazel_dep(name = "nanobind_bazel", version = "")
local_path_override(
    module_name = "nanobind_bazel",
    path = "../",
)
"""


def main():
    bazel_project = Path(sys.argv[1])
    module_bazel = bazel_project / "MODULE.bazel"
    if not module_bazel.exists():
        raise FileNotFoundError(module_bazel)

    content = module_bazel.read_text()
    module_bazel.write_text(
        re.sub(
            r"bazel_dep\(name = \"nanobind_bazel\", version = [\w\".]*\)",
            _LOCAL_NANOBIND_BAZEL,
            content,
        )
    )

if __name__ == "__main__":
    main()
