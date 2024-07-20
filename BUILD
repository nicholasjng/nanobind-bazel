load("@bazel_skylib//lib:selects.bzl", "selects")
load("@bazel_skylib//rules:common_settings.bzl", "bool_flag", "string_flag")

licenses(["notice"])

exports_files([
    "LICENSE",
    "pybind11_bazel.LICENSE",
    "stubgen_wrapper.py",
])

bool_flag(
    name = "minsize",
    build_setting_default = True,
)

config_setting(
    name = "with_sizeopts",
    flag_values = {":minsize": "True"},
)

config_setting(
    name = "without_sizeopts",
    flag_values = {":minsize": "False"},
)

string_flag(
    name = "py-limited-api",
    build_setting_default = "unset",
    values = [
        "cp312",
        "cp313",
        "unset",
    ],
)

config_setting(
    name = "cp312",
    flag_values = {":py-limited-api": "cp312"},
)

config_setting(
    name = "cp313",
    flag_values = {":py-limited-api": "cp313"},
)

config_setting(
    name = "pyunlimitedapi",
    flag_values = {":py-limited-api": "unset"},
)

config_setting(
    name = "MacReleaseBuild",
    constraint_values = [
        "@platforms//os:macos",
    ],
    values = {
        "compilation_mode": "opt",
    },
)

config_setting(
    name = "LinuxReleaseBuild",
    constraint_values = [
        "@platforms//os:linux",
    ],
    values = {
        "compilation_mode": "opt",
    },
)

config_setting(
    name = "WindowsReleaseBuild",
    constraint_values = [
        "@platforms//os:windows",
    ],
    values = {
        "compilation_mode": "opt",
    },
)

selects.config_setting_group(
    name = "releaseBuild",
    match_any = [
        ":LinuxReleaseBuild",
        ":MacReleaseBuild",
        ":WindowsReleaseBuild",
    ],
)

selects.config_setting_group(
    name = "unix",
    match_any = [
        "@platforms//os:linux",
        "@platforms//os:macos",
    ],
)

# Config setting indicating that stable ABI extension build was requested.
selects.config_setting_group(
    name = "stable-abi",
    match_any = [
        ":cp312",
        ":cp313",
    ],
)

# A stable ABI build on Linux or Mac.
# This requires a different extension name (.abi3.so instead of just .so).
selects.config_setting_group(
    name = "stable-abi-unix",
    match_all = [
        ":stable-abi",
        ":unix",
    ],
)

# An unlimited Python ABI build on Linux or Mac. Produces a regular .so file.
selects.config_setting_group(
    name = "unstable-abi-unix",
    match_all = [
        ":pyunlimitedapi",
        ":unix",
    ],
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
        "@rules_cc//cc/compiler:msvc-cl",
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
