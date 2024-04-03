"""Helper flags for nanobind build options."""

def sizeopts():
    return select({
        "@nanobind_bazel//:msvc_and_minsize": ["/Os"],
        "@nanobind_bazel//:nonmsvc_and_minsize": ["-Os"],
        "@nanobind_bazel//:without_sizeopts": [],
    })

def stripopts():
    """Linker options to strip external and debug symbols from nanobind release builds."""
    return select({
        "@nanobind_bazel//:MacReleaseBuild": ["-Wl,-x", "-Wl,-S"],
        "@nanobind_bazel//:LinuxReleaseBuild": ["-Wl,-s"],
        "//conditions:default": [],
    })

def sizedefs():
    return select({
        "@nanobind_bazel//:with_sizeopts": ["NB_COMPACT_ASSERTIONS"],
        "@nanobind_bazel//:without_sizeopts": [],
    })

# Define the Python version hex if stable ABI builds are requested.
def py_limited_api():
    return select({
        "@nanobind_bazel//:cp312": ["Py_LIMITED_API=0x030C0000"],
        "@nanobind_bazel//:cp313": ["Py_LIMITED_API=0x030D0000"],
        "@nanobind_bazel//:pyunlimitedapi": [],
    })

# Get the name for a built nanobind extension based on target platform
# and stable ABI build yes/no.
def extension_name(name):
    return select({
        "@platforms//os:windows": name + ".pyd",
        "@nanobind_bazel//:stable-abi-unix": name + ".abi3.so",
        "@nanobind_bazel//:unstable-abi-unix": name + ".so",
    })
