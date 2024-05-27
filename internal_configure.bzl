"""
Module extension for configuring nanobind_bazel.
Pins nanobind and robin-map to a specific version.
To override versions, use a `git_override` of nanobind-bazel,
and patch the version and integrity parameter of the `http_archive`s below.
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def _internal_configure_extension_impl(_):
    robin_map_version = "1.3.0"
    http_archive(
        name = "robin_map",
        build_file = "//:robin_map.BUILD",
        strip_prefix = "robin-map-%s" % robin_map_version,
        integrity = "sha256-qEJK07Cv/UxX7Sbw89iilgTw4fLvIIn0l/YUsclMcjY=",
        urls = ["https://github.com/Tessil/robin-map/archive/refs/tags/v%s.tar.gz" % robin_map_version],
    )

    nanobind_version = "2.0.0"
    http_archive(
        name = "nanobind",
        build_file = "//:nanobind.BUILD",
        strip_prefix = "nanobind-%s" % nanobind_version,
        integrity = "sha256-LnBydITtt6hkXSb2qfZzUqZoZXw03npgO/nGjly/j/k=",
        urls = ["https://github.com/wjakob/nanobind/archive/refs/tags/v%s.tar.gz" % nanobind_version],
    )

internal_configure_extension = module_extension(implementation = _internal_configure_extension_impl)
