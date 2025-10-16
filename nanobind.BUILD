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
    "nb_free_threading",
    "nb_sizeopts",
    "nb_stripopts",
    "py_limited_api",
)
load("@rules_cc//cc:defs.bzl", "cc_library")
load("@rules_python//python:defs.bzl", "py_library")
load("@rules_python//python:features.bzl", "features")

licenses(["notice"])

package(default_visibility = ["//visibility:public"])

cc_library(
    name = "nanobind",
    srcs = glob(
        include = ["src/*.cpp"],
        exclude = ["src/nb_combined.cpp"],
    ),
    additional_linker_inputs = select({
        "@platforms//os:macos": [":cmake/darwin-ld-cpython.sym"],
        "//conditions:default": [],
    }),
    copts = nb_common_opts(mode = "library") + nb_sizeopts(),
    defines = py_limited_api() + nb_free_threading(),
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
    deps = ["@robin_map"] + select(
        {
            "@nanobind_bazel//:stable-abi": [
                "@rules_python//python/cc:current_py_cc_headers_abi3" if getattr(features, "headers_abi3", False) else "@rules_python//python/cc:current_py_cc_headers",
            ],
            "//conditions:default": ["@rules_python//python/cc:current_py_cc_headers"],
        },
    ),
)

py_library(
    name = "stubgen",
    srcs = ["src/stubgen.py"],
    imports = ["src"],
    deps = ["@pypi__typing_extensions//:lib"],
)
