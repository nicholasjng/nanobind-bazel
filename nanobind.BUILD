"""
A cross-platform nanobind Bazel BUILD.
Supports size and linker optimizations across all three major operating systems.
Size optimizations used: -Os, LTO
Linker optimizations used: LTCG (MSVC on Windows), linker response file (macOS only).
"""

licenses(["notice"])

package(default_visibility = ["//visibility:public"])

config_setting(
    name = "msvc",
    flag_values = {"@bazel_tools//tools/cpp:compiler": "msvc-cl"},
)

cc_library(
    name = "nanobind",
    srcs = glob(["src/*.cpp"]),
    additional_linker_inputs = select({
        "@platforms//os:macos": [":cmake/darwin-ld-cpython.sym"],
        "//conditions:default": [],
    }),
    copts = select({
        ":msvc": [
            "/EHsc",  # exceptions
            "/Os",  # size optimizations
            "/GL",  # LTO / whole program optimization
        ],
        # clang and gcc, across all platforms.
        "//conditions:default": [
            "-fexceptions",
            "-flto",
            "-Os",
        ],
    }),
    includes = [
        "ext/robin_map/include",
        "include",
    ],
    linkopts = select({
        ":msvc": ["/LTCG"],  # MSVC.
        "@platforms//os:macos": ["-Wl,@$(location :cmake/darwin-ld-cpython.sym)"],  # Apple.
        "//conditions:default": [],
    }),
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
