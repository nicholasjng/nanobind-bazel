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

    nanobind_version = "2.2.0"
    http_archive(
        name = "nanobind",
        build_file = "//:nanobind.BUILD",
        strip_prefix = "nanobind-%s" % nanobind_version,
        # integrity = "sha256-LnBydITtt6hkXSb2qfZzUqZoZXw03npgO/nGjly/j/k=",
        urls = ["https://github.com/wjakob/nanobind/archive/refs/tags/v%s.tar.gz" % nanobind_version],
    )

    typing_extensions_version = "4.12.2"
    http_archive(
        name = "pypi__typing_extensions",
        build_file = "//:typing_extensions.BUILD",
        strip_prefix = "typing_extensions-%s" % typing_extensions_version,
        integrity = "sha256-Gn6tVcflWd1N7ohW46iLQSJav+HOjfV7fBORX+Eh/7g=",
        urls = ["https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-%s.tar.gz" % typing_extensions_version],
    )

internal_configure_extension = module_extension(implementation = _internal_configure_extension_impl)
