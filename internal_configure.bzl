"""
Module extension for configuring nanobind_bazel.
Pins nanobind and robin-map to a specific version.
To override versions, use a `git_override` of nanobind-bazel,
and patch the version and integrity parameter of the `http_archive`s below.
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def _internal_configure_extension_impl(_):
    robin_map_version = "1.2.1"
    http_archive(
        name = "robin_map",
        build_file = "//:robin_map.BUILD",
        strip_prefix = "robin-map-%s" % robin_map_version,
        integrity = "sha256-K1TSwd4vc76lxR1dy9ZIE6CMrxv93P3u5Aq3TpWZ6OM=",
        urls = ["https://github.com/Tessil/robin-map/archive/refs/tags/v%s.tar.gz" % robin_map_version],
    )

    nanobind_version = "1.9.2"
    http_archive(
        name = "nanobind",
        build_file = "//:nanobind.BUILD",
        strip_prefix = "nanobind-%s" % nanobind_version,
        integrity = "sha256-FJo9pAsKmIUT2M9ecdswNzc4I1BaPJL4e5iMktfgqzQ=",
        urls = ["https://github.com/wjakob/nanobind/archive/refs/tags/v%s.tar.gz" % nanobind_version],
    )

internal_configure_extension = module_extension(implementation = _internal_configure_extension_impl)
