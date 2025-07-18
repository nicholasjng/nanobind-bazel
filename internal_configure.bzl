"""
Module extension for configuring nanobind_bazel.
Pins nanobind and robin-map to a specific version.
To override versions, use a `git_override` of nanobind-bazel,
and patch the version and integrity parameter of the `http_archive`s below.
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def _internal_configure_extension_impl(_):
    robin_map_version = "1.4.0"
    http_archive(
        name = "robin_map",
        build_file = "//:robin_map.BUILD",
        strip_prefix = "robin-map-%s" % robin_map_version,
        integrity = "sha256-eTDb+WNKz8Amhth/YVwPTzMTWUgTC4kiMxwW2QoDJQw=",
        urls = ["https://github.com/Tessil/robin-map/archive/refs/tags/v%s.tar.gz" % robin_map_version],
    )

    nanobind_version = "2.8.0"
    http_archive(
        name = "nanobind",
        build_file = "//:nanobind.BUILD",
        strip_prefix = "nanobind-%s" % nanobind_version,
        integrity = "sha256-F1BvHvXJJJEYOrKCQvpPZY2WJf5PkczR0TWMtuX1rLY=",
        urls = ["https://github.com/wjakob/nanobind/archive/refs/tags/v%s.tar.gz" % nanobind_version],
    )

    typing_extensions_version = "4.13.2"
    http_archive(
        name = "pypi__typing_extensions",
        build_file = "//:typing_extensions.BUILD",
        strip_prefix = "typing_extensions-%s" % typing_extensions_version,
        integrity = "sha256-5sgSGb1on1GGXZ43KZHFQL2jOgN51Vc83bmjoj98qu8=",
        urls = ["https://files.pythonhosted.org/packages/f6/37/23083fcd6e35492953e8d2aaaa68b860eb422b34627b13f2ce3eb6106061/typing_extensions-%s.tar.gz" % typing_extensions_version],
    )

internal_configure_extension = module_extension(implementation = _internal_configure_extension_impl)
