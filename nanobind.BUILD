"""
A cross-platform nanobind Bazel build.
Supports size and linker optimizations across all three major operating systems.
Size optimizations used: -Os, LTO.
Linker optimizations used: LTO (clang, gcc) / LTCG (MSVC), linker response file (macOS only).
"""

load("@nanobind_bazel//:helpers.bzl", "py_limited_api", "sizedefs", "sizeopts")

licenses(["notice"])

package(default_visibility = ["//visibility:public"])

_NB_DEPS = [
    "@robin_map",
    "@rules_python//python/cc:current_py_cc_headers",
] + select({
    # we need to link in the Python libs only on Windows to signal to the linker that it
    # needs to go searching for these symbols at runtime.
    # TODO: This seems Windows-specific, so change to `@platforms//os:windows`?
    "@rules_cc//cc/compiler:msvc-cl": ["@rules_python//python/cc:current_py_cc_libs"],
    "//conditions:default": [],
})

cc_library(
    name = "nanobind",
    srcs = glob(["src/*.cpp"]),
    additional_linker_inputs = select({
        "@platforms//os:macos": [":cmake/darwin-ld-cpython.sym"],
        "//conditions:default": [],
    }),
    copts = select({
        "@rules_cc//cc/compiler:msvc-cl": [
            "/EHsc",  # exceptions.
        ],
        # clang and gcc, across all platforms.
        "//conditions:default": [
            "-fexceptions",
            "-fno-strict-aliasing",
        ],
    }) + sizeopts(),
    defines = py_limited_api(),
    includes = ["include"],
    linkopts = select({
        "@platforms//os:linux": [
            "-Wl,--gc-sections",
        ],
        "@platforms//os:macos": [
            "-Wl,@$(location :cmake/darwin-ld-cpython.sym)",  # Apple.
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
    deps = _NB_DEPS,
)
