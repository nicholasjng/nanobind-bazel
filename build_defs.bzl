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
load(
    "@nanobind_bazel//:helpers.bzl",
    "extension_name",
    "nb_common_opts",
    "nb_sizeopts",
)

NANOBIND_COPTS = nb_common_opts() + nb_sizeopts()
NANOBIND_DEPS = [Label("@nanobind//:nanobind")]

def nanobind_extension(
        name,
        domain = "",
        srcs = [],
        copts = [],
        deps = [],
        local_defines = [],
        **kwargs):
    """A C++ Python extension library built with nanobind.

    Given a name $NAME, defines the following targets:
    1. $NAME.so, a shared object library for use on Linux/Mac.
    2. $NAME.abi3.so, a copy of $NAME.so for Linux/Mac,
        indicating that it is compatible with the Python stable ABI.
    3. $NAME.pyd, a copy of $NAME.so for use on Windows.
    4. $NAME, an alias pointing to the appropriate library
        depending on the target platform.

    Args:
        name: str
            A name for this target. This becomes the Python module name
            used by the resulting nanobind extension.
        domain: str, default ''
            The nanobind domain to set for this extension. A nanobind domain is
            an optional attribute that can be set to scope extension code to a named
            domain, which avoids conflicts with other extensions.
        srcs: list
            A list of sources and headers to go into this target.
        copts: list
            A list of compiler optimizations. Augmented with nanobind-specific
            compiler optimizations by default.
        deps: list
            A list of dependencies of this extension.
        local_defines: list
            A list of preprocessor defines to set for this target.
            Augmented with -DNB_DOMAIN=$DOMAIN if the domain argument is given.
        **kwargs: Any
            Keyword arguments matching the cc_binary rule arguments, to be passed
            directly to the resulting cc_binary target.
    """
    if domain != "":
        NANOBIND_DOMAIN = ["NB_DOMAIN={}".format(domain)]
    else:
        NANOBIND_DOMAIN = []

    native.cc_binary(
        name = name + ".so",
        srcs = srcs,
        copts = copts + NANOBIND_COPTS,
        deps = deps + NANOBIND_DEPS,
        local_defines = local_defines + NANOBIND_DOMAIN,
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
        deps = [],
        **kwargs):
    native.cc_library(
        name = name,
        copts = copts + NANOBIND_COPTS,
        deps = deps + NANOBIND_DEPS,
        **kwargs
    )

def nanobind_test(
        name,
        copts = [],
        deps = [],
        **kwargs):
    native.cc_test(
        name = name,
        copts = copts + NANOBIND_COPTS,
        deps = deps + NANOBIND_DEPS,
        **kwargs
    )
