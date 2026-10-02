load("@rules_python//python:defs.bzl", "py_library")

package(default_visibility = ["//visibility:public"])

py_library(
    name = "lib",
    srcs = glob(["nanobind_backend/**/*.py"]),
    data = glob(
        [
            "nanobind_backend/**/*.so",
            "nanobind_backend/**/*.pyd",
            # Shared libraries vendored by wheel repair tools:
            # delvewheel (Windows) and auditwheel (Linux) use a sibling
            # `nanobind_backend.libs` directory, delocate (macOS) uses `.dylibs`.
            "nanobind_backend.libs/**",
            "nanobind_backend/.dylibs/**",
        ],
        allow_empty = True,
    ),
    imports = ["."],
)
