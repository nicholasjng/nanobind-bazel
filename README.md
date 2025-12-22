# nanobind-bazel: Bazel build rules for C++ Python bindings with nanobind

This repo contains Bazel build defs for Python bindings created with [nanobind](https://github.com/wjakob/nanobind).

Here's the full list of exported rules:

- `nanobind_extension`, building a Python extension containing the bindings as a `*.so` file.
These extensions can be used e.g. as a `data` dependency for a `py_library` target.
- `nanobind_stubgen`, a rule pointing to a `py_binary` to create a Python stub file from a previously built `nanobind_extension`. (Available only with `nanobind>=2.0.0`.)
- `nanobind_library`, a C++ library target that can be used as a dependency of a `nanobind_extension`. Directly forwards its arguments to the `cc_library` rule.
- `nanobind_shared_library`, a C++ shared library target that can be used to
produce smaller objects in scenarios with multiple independent bindings extensions. Directly forwards its arguments to the `cc_shared_library` rule.
- `nanobind_static_library`, a C++ static library with nanobind as a dependency. Currently experimental because the underlying `cc_static_library` is considered experimental.
- `nanobind_test`, a C++ test for a `nanobind_library`. Forwards its argument to a `cc_test`.

Each target is given nanobind's specific build flags, optimizations and dependencies.

## Usage with bzlmod

nanobind-bazel is published to the Bazel Central Registry (BCR). To use it, specify it as a `bazel_dep`:

```
# the version of nanobind-bazel is exactly equal to the version of the internally used nanobind.
# In this case, we are building bindings with nanobind==2.10.2.
bazel_dep(name = "nanobind_bazel", version = "2.10.2")
```

To instead use a development version, you can declare a `git_override()` dependency in your MODULE.bazel:

```
bazel_dep(name = "nanobind_bazel", version = "")
git_override(
    module_name = "nanobind_bazel",
    commit = "COMMIT_SHA", # replace this with the actual commit SHA you want.
    remote = "https://github.com/nicholasjng/nanobind-bazel",
)
```

In local development scenarios, you can clone nanobind-bazel to your machine and then declare it as a `local_path_override()` like so:

```
bazel_dep(name = "nanobind_bazel", version = "")
local_path_override(
    module_name = "nanobind_bazel",
    path = "path/to/nanobind-bazel/", # replace this with the actual path.
)
```

## Bazel versions

This library relies on the ability to pass inputs to the linker in `cc_library` targets, which became available starting in Bazel 6.4.0.
Since the release of Bazel 8, the minimum Bazel version compatible with this project is Bazel 7.0.0.

In general, since Bazel 7 enabled bzlmod by default, no more intentional development efforts are made to support the workspace system.

## Licenses and acknowledgements

This library is heavily inspired by the [pybind11-bazel](https://github.com/pybind/pybind11_bazel) project, which does the same thing for pybind11.
As I have used some of the code from that repository, its [license](pybind11_bazel.LICENSE) is included here, too.

In contrast to that project, though, nanobind does not support Python interpreter embedding, and endorses a few more size-related optimizations which I have included here.

## Known issues

### Stable ABI extension builds on Windows

Stable ABI extensions (i.e., those with `Py_LIMITED_API` defined and set to a target Python version) on Windows are linked incorrectly on `nanobind_bazel<=2.9.2`.

This is because of a bug in a `rules_python` header target, which links against the wrong `.lib` file on Windows in the stable ABI case, leading to DLL version mismatches when attempting to load such an extension into a Python interpreter different from the one used to build the extension.

To build nanobind extensions on Windows targeting the stable ABI, you must also upgrade to `rules_python>=1.7.0`, which contains the fix.
For more information about linking Python extensions on Windows, you can refer to [this pull request](https://github.com/bazel-contrib/rules_python/pull/3274) and the comments therein.

## Contributing

I welcome all contributions.
If you encounter problems using these rules in your Bazel setup, please open an issue.
If you'd like to help maintain the project, write me a message.
