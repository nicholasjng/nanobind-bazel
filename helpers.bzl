"""Helper flags for nanobind build options."""

def sizeopts():
    return select({
        "@nanobind_bazel//:msvc_and_minsize": ["/Os"],
        "@nanobind_bazel//:nonmsvc_and_minsize": ["-Os"],
        "@nanobind_bazel//:without_sizeopts": [],
    })

def sizedefs():
    return select({
        "@nanobind_bazel//:with_sizeopts": ["NB_COMPACT_ASSERTS"],
        "@nanobind_bazel//:without_sizeopts": [],
    })

# define the Python version hex if stable ABI builds are requested.
def pyversionhex():
    return select({
        "@nanobind_bazel//:cp312": ["Py_LIMITED_API=0x030C0000"],
        "@nanobind_bazel//:cp313": ["Py_LIMITED_API=0x030D0000"],
        "@nanobind_bazel//:pyunlimitedapi": [],
    })
