"""
Module extension for configuring nanobind_bazel.

Used exactly as in pybind11_bazel.
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def _parse_my_own_version_from_module_dot_bazel(module_ctx):
    lines = module_ctx.read(Label("//:MODULE.bazel")).split("\n")
    for line in lines:
        parts = line.split("\"")
        if parts[0] == "    version = ":
            return parts[1]
    fail("Failed to parse my own version from `MODULE.bazel`.")

def _internal_configure_extension_impl(module_ctx):
    version = _parse_my_own_version_from_module_dot_bazel(module_ctx)

    # Pin robin-map to its latest stable tag unconditionally.
    http_archive(
        name = "robin_map",
        build_file = "//:robin_map.BUILD",
        strip_prefix = "robin-map-1.2.1",
        urls = ["https://github.com/Tessil/robin-map/archive/refs/tags/v1.2.1.tar.gz"],
    )

    # TODO: Allow commit hashes here, and mention how to include commits
    # TODO: in README.
    # Handle updated tags in the Bazel Central Registry, which are suffixed with ".bzl.$N",
    # where N is the revision number.
    version = version.split(".bzl.")[0]
    http_archive(
        name = "nanobind",
        build_file = "//:nanobind.BUILD",
        strip_prefix = "nanobind-%s" % version,
        urls = ["https://github.com/wjakob/nanobind/archive/v%s.zip" % version],
    )

internal_configure_extension = module_extension(implementation = _internal_configure_extension_impl)
