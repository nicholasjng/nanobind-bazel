"""
A cross-platform nanobind Bazel BUILD.
Supports size and linker optimizations across all three major operating systems.
Size optimizations used: -Os, LTO
Linker optimizations used: LTCG (MSVC on Windows), linker response file (macOS only).
"""

load("@bazel_skylib//lib:selects.bzl", "selects")
load("@bazel_skylib//rules:common_settings.bzl", "bool_flag")
load("@nanobind_bazel//:helpers.bzl", "sizeopts")

licenses(["notice"])

# TODO: Change this when cleaning up exports later.
package(default_visibility = ["//visibility:public"])

bool_flag(
    name = "minsize",
    build_setting_default = False,
)

config_setting(
    name = "with_sizeopts",
    flag_values = {":minsize": "True"},
)

config_setting(
    name = "without_sizeopts",
    flag_values = {":minsize": "False"},
)

config_setting(
    name = "msvc",
    flag_values = {"@bazel_tools//tools/cpp:compiler": "msvc-cl"},
)

# Is the currently configured C++ compiler not MSVC?
selects.config_setting_group(
    name = "nonmsvc",
    match_any = [
        "@rules_cc//cc/compiler:gcc",
        "@rules_cc//cc/compiler:clang",
        "@rules_cc//cc/compiler:clang-cl",
        "@rules_cc//cc/compiler:mingw-gcc",
    ],
)

selects.config_setting_group(
    name = "msvc_and_minsize",
    match_all = [
        ":msvc",
        ":with_sizeopts",
    ],
)

selects.config_setting_group(
    name = "nonmsvc_and_minsize",
    match_all = [
        ":nonmsvc",
        ":with_sizeopts",
    ],
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
            "/GL",  # LTO / whole program optimization
        ],
        # clang and gcc, across all platforms.
        "//conditions:default": [
            "-fexceptions",
            "-flto",
            "-Os",
        ],
    }) + sizeopts(),
    includes = [
        "ext/robin_map/include",
        "include",
    ],
    linkopts = select({
        ":msvc": ["/LTCG"],  # MSVC.
        "@platforms//os:macos": [
            "-Wl,@$(location :cmake/darwin-ld-cpython.sym)",  # Apple.
            "-Wl,-dead_strip",
        ],
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
