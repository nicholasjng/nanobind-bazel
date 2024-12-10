"""Helper flags for nanobind build options."""

def nb_common_opts(mode = "user"):
    unix_common_opts = [
        "-fPIC",
        "-fvisibility=hidden",
        "-fno-strict-aliasing",
    ]

    if mode == "user":
        # user-facing code gets stack smashing protection
        # disable flag.
        unix_common_opts.append("-fno-stack-protector")

    return select({
        "@nanobind_bazel//:unix": unix_common_opts,
        "//conditions:default": [],
    })

def nb_sizeopts():
    return select({
        "@nanobind_bazel//:msvc_and_minsize": ["/Os"],
        "@nanobind_bazel//:nonmsvc_and_minsize": ["-Os"],
        "@nanobind_bazel//:without_sizeopts": [],
    })

def nb_stripopts():
    """Linker options to strip external and debug symbols from nanobind release builds."""
    return select({
        "@nanobind_bazel//:MacReleaseBuild": ["-Wl,-x", "-Wl,-S"],
        "@nanobind_bazel//:LinuxReleaseBuild": ["-Wl,-s"],
        "//conditions:default": [],
    })

def maybe_compact_asserts():
    return select({
        "@nanobind_bazel//:releaseBuild": ["NB_COMPACT_ASSERTIONS"],
        "//conditions:default": [],
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
        Label("@platforms//os:windows"): name + ".pyd",
        "@nanobind_bazel//:stable-abi-unix": name + ".abi3.so",
        "@nanobind_bazel//:unstable-abi-unix": name + ".so",
    })

# Optionally add a define for free-threaded nanobind builds.
def nb_free_threading():
    return select({
        "@nanobind_bazel//:with_free_threading": ["NB_FREE_THREADED"],
        "@nanobind_bazel//:without_free_threading": [],
    })
