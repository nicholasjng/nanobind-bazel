"""
Build defs for nanobind.

The ``nanobind_extension`` corresponds to a ``cc_binary``,
the ``nanobind_library`` to a ``cc_library``,
and the ``nanobind_test`` to a ``cc_test``.

For creating Python bindings, the most likely case is a ``nanobind_extension``
built using the C++ source files containing the nanobind module definition,
which can then be included e.g. as a `data` input in a ``native.py_library``.
"""

load("@bazel_skylib//rules:copy_file.bzl", "copy_file")
load("@nanobind_bazel//:helpers.bzl", "extension_name")

NANOBIND_COPTS = select({
    Label("@rules_cc//cc/compiler:msvc-cl"): [],
    "//conditions:default": ["-fexceptions", "-fno-strict-aliasing"],
})

NANOBIND_FEATURES = [
    "-use_header_modules",
    "-parse_headers",
]

NANOBIND_DEPS = [
    Label("@nanobind"),
    "@rules_python//python/cc:current_py_cc_headers",
]

# A C++ Python extension library built with nanobind.
# Given a name $NAME, defines the following targets:
# 1. $NAME.so, a shared object library for use on Linux/Mac.
# 2. $NAME.abi3.so, a copy of $NAME.so for Linux/Mac,
#     indicating that it is compatible with the Python stable ABI.
# 3. $NAME.pyd, a copy of $NAME.so for use on Windows.
# 4. $NAME, an alias pointing to the appropriate library
#    depending on the target platform.
def nanobind_extension(
        name,
        srcs = [],
        copts = [],
        features = [],
        deps = [],
        **kwargs):
    native.cc_binary(
        name = name + ".so",
        srcs = srcs,
        copts = copts + NANOBIND_COPTS,
        features = features + NANOBIND_FEATURES,
        deps = deps + NANOBIND_DEPS,
        linkshared = True,  # Python extensions need to be shared libs.
        **kwargs
    )

    copy_file(
        name = name + "_copy_so_to_abi3_so",
        src = name + ".so",
        out = name + ".abi3.so",
    )

    copy_file(
        name = name + "_copy_so_to_pyd",
        src = name + ".so",
        out = name + ".pyd",
    )

    native.alias(
        name = name,
        actual = extension_name(name),
    )

def nanobind_library(
        name,
        copts = [],
        features = [],
        deps = [],
        **kwargs):
    native.cc_library(
        name = name,
        copts = copts + NANOBIND_COPTS,
        features = features + NANOBIND_FEATURES,
        deps = deps + NANOBIND_DEPS,
        **kwargs
    )

def nanobind_test(
        name,
        copts = [],
        features = [],
        deps = [],
        **kwargs):
    native.cc_test(
        name = name,
        copts = copts + NANOBIND_COPTS,
        features = features + NANOBIND_FEATURES,
        deps = deps + NANOBIND_DEPS,
        **kwargs
    )
