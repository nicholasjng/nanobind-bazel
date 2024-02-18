licenses(["notice"])

package(default_visibility = ["//visibility:public"])

cc_library(
    name = "robin_map",
    hdrs = glob([
        "include/tsl/*.h",
    ]),
    copts = ["-fexceptions"],
    features = ["-use_header_modules"],  # Incompatible with -fexceptions.
    strip_include_prefix = "include",
)
