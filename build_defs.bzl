"""
Build defs for nanobind.

The ``nanobind_extension`` corresponds to a ``cc_binary``,
the ``nanobind_library`` to a ``cc_library``,
and the ``nanobind_test`` to a ``cc_test``.

For creating Python bindings, the most likely case is a ``nanobind_extension``
built using the C++ source files containing the nanobind module definition,
which can then be included e.g. as a `data` input in a ``native.py_library``.
"""

NANOBIND_COPTS = select({
    Label("@nanobind//:msvc"): [],
    "//conditions:default": ["-fexceptions", "-fvisibility=hidden"],
})

NANOBIND_FEATURES = [
    "-use_header_modules",
    "-parse_headers",
]

NANOBIND_DEPS = [
    Label("@nanobind"),
    "@rules_python//python/cc:current_py_cc_headers",
]

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
        linkshared = True,
        linkstatic = True,
        **kwargs
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
