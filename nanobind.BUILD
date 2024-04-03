"""
A cross-platform nanobind Bazel build.
Supports size and linker optimizations across all three major operating systems.
Size optimizations used: -Os, LTO.
Linker optimizations used: LTO (clang, gcc) / LTCG (MSVC), linker response file (macOS only).
"""

load("@nanobind_bazel//:helpers.bzl", "py_limited_api", "sizedefs", "sizeopts")

licenses(["notice"])

package(default_visibility = ["//visibility:public"])

cc_library(
    name = "nanobind",
    srcs = glob(["src/*.cpp"]),
    additional_linker_inputs = select({
        "@platforms//os:macos": [":cmake/darwin-ld-cpython.sym"],
        "//conditions:default": [],
    }),
    copts = select({
        "@platforms//os:macos": [
            "-fPIC",
            "-fvisibility=hidden",
            "-fno-strict-aliasing",
        ],
        "@platforms//os:linux": [
            "-fPIC",
            "-fvisibility=hidden",
            "-ffunction-sections",
            "-fdata-sections",
            "-fno-strict-aliasing",
        ],
        "//conditions:default": [],
    }) + sizeopts(),
    defines = py_limited_api(),
    features = ["-pic"],  # use a compiler flag instead.
    includes = ["include"],
    linkopts = select({
        "@platforms//os:linux": [
            "-Wl,-s",
            "-Wl,--gc-sections",
        ],
        "@platforms//os:macos": [
            # chained fixups on Apple platforms.
            "-Wl,@$(location :cmake/darwin-ld-cpython.sym)",
            "-Wl,-dead_strip",
            "-Wl,-x",
            "-Wl,-S",
        ],
        "//conditions:default": [],
    }),
    local_defines = sizedefs(),  # sizeopts apply to nanobind only.
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
