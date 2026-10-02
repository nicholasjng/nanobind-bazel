load("@bazel_skylib//lib:selects.bzl", "selects")
load("@bazel_skylib//rules:common_settings.bzl", "bool_flag", "string_flag")

licenses(["notice"])

exports_files([
    "LICENSE",
    "pybind11_bazel.LICENSE",
    "stubgen_wrapper.py",
])

alias(
    name = "nanobind",
    actual = "@nanobind//:nanobind",
    visibility = ["//visibility:public"],
)

alias(
    name = "nanobind_shared",
    actual = "@nanobind//:nanobind_shared",
    visibility = ["//visibility:public"],
)

alias(
    name = "libnanobind",
    actual = "@nanobind//:libnanobind",
    visibility = ["//visibility:public"],
)

bool_flag(
    name = "split-mode",
    build_setting_default = False,
    visibility = ["//visibility:public"],
)

config_setting(
    name = "with_split_mode",
    flag_values = {":split-mode": "True"},
    visibility = ["//visibility:public"],
)

bool_flag(
    name = "minsize",
    build_setting_default = True,
    visibility = ["//visibility:public"],
)

config_setting(
    name = "with_sizeopts",
    flag_values = {":minsize": "True"},
    visibility = ["//visibility:public"],
)

config_setting(
    name = "without_sizeopts",
    flag_values = {":minsize": "False"},
    visibility = ["//visibility:public"],
)

string_flag(
    name = "py-limited-api",
    build_setting_default = "unset",
    values = [
        "cp310",
        "cp311",
        "cp312",
        "cp313",
        "cp314",
        "cp315",
        "cp315t",
        "unset",
    ],
    visibility = ["//visibility:public"],
)

config_setting(
    name = "cp310",
    flag_values = {":py-limited-api": "cp310"},
    visibility = ["//visibility:public"],
)

config_setting(
    name = "cp311",
    flag_values = {":py-limited-api": "cp311"},
    visibility = ["//visibility:public"],
)

config_setting(
    name = "cp312",
    flag_values = {":py-limited-api": "cp312"},
    visibility = ["//visibility:public"],
)

config_setting(
    name = "cp313",
    flag_values = {":py-limited-api": "cp313"},
    visibility = ["//visibility:public"],
)

config_setting(
    name = "cp314",
    flag_values = {":py-limited-api": "cp314"},
    visibility = ["//visibility:public"],
)

config_setting(
    name = "cp315",
    flag_values = {":py-limited-api": "cp315"},
    visibility = ["//visibility:public"],
)

config_setting(
    name = "cp315t",
    flag_values = {":py-limited-api": "cp315t"},
    visibility = ["//visibility:public"],
)

config_setting(
    name = "pyunlimitedapi",
    flag_values = {":py-limited-api": "unset"},
    visibility = ["//visibility:public"],
)

config_setting(
    name = "MacReleaseBuild",
    constraint_values = [
        "@platforms//os:macos",
    ],
    values = {
        "compilation_mode": "opt",
    },
    visibility = ["//visibility:public"],
)

config_setting(
    name = "LinuxReleaseBuild",
    constraint_values = [
        "@platforms//os:linux",
    ],
    values = {
        "compilation_mode": "opt",
    },
    visibility = ["//visibility:public"],
)

config_setting(
    name = "WindowsReleaseBuild",
    constraint_values = [
        "@platforms//os:windows",
    ],
    values = {
        "compilation_mode": "opt",
    },
    visibility = ["//visibility:public"],
)

selects.config_setting_group(
    name = "releaseBuild",
    match_any = [
        ":LinuxReleaseBuild",
        ":MacReleaseBuild",
        ":WindowsReleaseBuild",
    ],
    visibility = ["//visibility:public"],
)

selects.config_setting_group(
    name = "unix",
    match_any = [
        "@platforms//os:linux",
        "@platforms//os:macos",
    ],
    visibility = ["//visibility:public"],
)

# Config setting indicating that stable ABI extension build was requested.
selects.config_setting_group(
    name = "stable-abi",
    match_any = [
        ":cp310",
        ":cp311",
        ":cp312",
        ":cp313",
        ":cp314",
        ":cp315",
    ],
    visibility = ["//visibility:public"],
)

selects.config_setting_group(
    name = "stable-abi-ft",
    match_any = [
        ":cp315t",
    ],
    visibility = ["//visibility:public"],
)

selects.config_setting_group(
    name = "any-stable-abi",
    match_any = [
        ":stable-abi",
        ":stable-abi-ft",
    ],
    visibility = ["//visibility:public"],
)

# A stable ABI build on Linux or Mac.
# This requires a different extension name (.abi3.so instead of just .so).
selects.config_setting_group(
    name = "stable-abi-unix",
    match_all = [
        ":stable-abi",
        ":unix",
    ],
    visibility = ["//visibility:public"],
)

selects.config_setting_group(
    name = "stable-abi-ft-unix",
    match_all = [
        ":stable-abi-ft",
        ":unix",
    ],
    visibility = ["//visibility:public"],
)

# An unlimited Python ABI build on Linux or Mac. Produces a regular .so file.
selects.config_setting_group(
    name = "unstable-abi-unix",
    match_all = [
        ":pyunlimitedapi",
        ":unix",
    ],
    visibility = ["//visibility:public"],
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
    visibility = ["//visibility:public"],
)

selects.config_setting_group(
    name = "msvc_and_minsize",
    match_all = [
        "@rules_cc//cc/compiler:msvc-cl",
        ":with_sizeopts",
    ],
    visibility = ["//visibility:public"],
)

selects.config_setting_group(
    name = "nonmsvc_and_minsize",
    match_all = [
        ":nonmsvc",
        ":with_sizeopts",
    ],
    visibility = ["//visibility:public"],
)

config_setting(
    name = "linux_x86_64",
    constraint_values = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
)

config_setting(
    name = "linux_aarch64",
    constraint_values = [
        "@platforms//os:linux",
        "@platforms//cpu:aarch64",
    ],
)

config_setting(
    name = "linux_riscv64",
    constraint_values = [
        "@platforms//os:linux",
        "@platforms//cpu:riscv64",
    ],
)

config_setting(
    name = "macos_x86_64",
    constraint_values = [
        "@platforms//os:macos",
        "@platforms//cpu:x86_64",
    ],
)

config_setting(
    name = "macos_aarch64",
    constraint_values = [
        "@platforms//os:macos",
        "@platforms//cpu:aarch64",
    ],
)

config_setting(
    name = "windows_x86_64",
    constraint_values = [
        "@platforms//os:windows",
        "@platforms//cpu:x86_64",
    ],
)

config_setting(
    name = "windows_aarch64",
    constraint_values = [
        "@platforms//os:windows",
        "@platforms//cpu:aarch64",
    ],
)

[
    alias(
        name = "nanobind_backend_" + abi,
        actual = select({
            ":linux_x86_64": "@pypi__nanobind_backend_" + abi + "_linux_x86_64//:lib",
            ":linux_aarch64": "@pypi__nanobind_backend_" + abi + "_linux_aarch64//:lib",
            ":linux_riscv64": "@pypi__nanobind_backend_" + abi + "_linux_riscv64//:lib",
            ":macos_x86_64": "@pypi__nanobind_backend_" + abi + "_macos_x86_64//:lib",
            ":macos_aarch64": "@pypi__nanobind_backend_" + abi + "_macos_aarch64//:lib",
            ":windows_x86_64": "@pypi__nanobind_backend_" + abi + "_windows_x86_64//:lib",
        } | ({
            ":windows_aarch64": "@pypi__nanobind_backend_" + abi + "_windows_aarch64//:lib",
        } if abi != "cp310" else {})),
    )
    for abi in [
        "cp310",
        "cp311",
        "cp312",
        "cp313",
        "cp314",
        "cp315",
        "cp315t",
    ]
]

alias(
    name = "nanobind_backend_py315",
    actual = select({
        "@rules_python//python/config_settings:is_py_freethreaded": ":nanobind_backend_cp315t",
        "//conditions:default": ":nanobind_backend_cp315",
    }),
)

alias(
    name = "nanobind_backend",
    actual = select({
        "@rules_python//python/config_settings:is_python_3.10": ":nanobind_backend_cp310",
        "@rules_python//python/config_settings:is_python_3.11": ":nanobind_backend_cp311",
        "@rules_python//python/config_settings:is_python_3.12": ":nanobind_backend_cp312",
        "@rules_python//python/config_settings:is_python_3.13": ":nanobind_backend_cp313",
        "@rules_python//python/config_settings:is_python_3.14": ":nanobind_backend_cp314",
        "@rules_python//python/config_settings:is_python_3.15": ":nanobind_backend_py315",
    }),
    visibility = ["//visibility:public"],
)
