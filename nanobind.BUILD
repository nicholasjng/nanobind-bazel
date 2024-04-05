"""
A cross-platform nanobind Bazel build.
Supports size and linker optimizations across all three major operating systems.
Size optimizations used: -Os, LTO.
Linker optimizations used: Debug stripping (release mode), linker response file (macOS only).
"""

load(
    "@nanobind_bazel//:helpers.bzl",
    "maybe_compact_asserts",
    "nb_common_opts",
    "nb_sizeopts",
    "nb_stripopts",
    "py_limited_api",
)

licenses(["notice"])

package(default_visibility = ["//visibility:public"])

cc_library(
    name = "nanobind",
    srcs = glob(["src/*.cpp"]),
    additional_linker_inputs = select({
        "@platforms//os:macos": [":cmake/darwin-ld-cpython.sym"],
        "//conditions:default": [],
    }),
    copts = nb_common_opts(mode = "library") + nb_sizeopts(),
    defines = py_limited_api(),
    includes = ["include"],
    linkopts = select({
        "@platforms//os:linux": ["-Wl,--gc-sections"],
        "@platforms//os:macos": [
            # chained fixups on Apple platforms.
            "-Wl,@$(location :cmake/darwin-ld-cpython.sym)",
            "-Wl,-dead_strip",
        ],
        "//conditions:default": [],
    }) + nb_stripopts(),
    local_defines = maybe_compact_asserts(),
    textual_hdrs = glob(
        [
            "include/**/*.h",
            "src/*.h",
        ],
    ),
    deps = [
        "@robin_map",
        "@rules_python//python/cc:current_py_cc_headers",
    ],
)
