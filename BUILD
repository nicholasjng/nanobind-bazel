load("@bazel_skylib//lib:selects.bzl", "selects")
load("@bazel_skylib//rules:common_settings.bzl", "bool_flag", "string_flag")

licenses(["notice"])

exports_files(["LICENSE"])

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
