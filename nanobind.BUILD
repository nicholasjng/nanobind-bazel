"""
A cross-platform nanobind Bazel BUILD.
Supports size and linker optimizations across all three major operating systems.
Size optimizations used: -Os, LTO
Linker optimizations used: LTCG (MSVC on Windows), linker response file (macOS only).
"""

load("@nanobind_bazel//:helpers.bzl", "pyversionhex", "sizedefs", "sizeopts")

licenses(["notice"])

# TODO: Change this when cleaning up exports later.
package(default_visibility = ["//visibility:public"])

cc_library(
    name = "nanobind",
    srcs = glob(["src/*.cpp"]),
    additional_linker_inputs = select({
        "@platforms//os:macos": [":cmake/darwin-ld-cpython.sym"],
        "//conditions:default": [],
    }),
    copts = select({
        "@rules_cc//cc/compiler:msvc-cl": [
            "/EHsc",  # exceptions
            "/GL",  # LTO / whole program optimization
        ],
        # clang and gcc, across all platforms.
        "//conditions:default": [
            "-fexceptions",
            "-flto",
        ],
    }) + sizeopts(),
    defines = pyversionhex(),
    includes = [
        "ext/robin_map/include",
        "include",
    ],
    linkopts = select({
        "@rules_cc//cc/compiler:msvc-cl": ["/LTCG"],  # MSVC.
        "@platforms//os:macos": [
            "-Wl,@$(location :cmake/darwin-ld-cpython.sym)",  # Apple.
            "-Wl,-dead_strip",
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
