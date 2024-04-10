# nanobind-bazel: Bazel build rules for C++ Python bindings with nanobind

This repo contains Bazel build defs for Python bindings created with [nanobind](https://github.com/wjakob/nanobind).

Here's the full list of exported rules:

- `nanobind_extension`, building a Python extension containing the bindings as a `*.so` file.
These extensions can be used e.g. as a `data` dependency for a `py_library` target.
- `nanobind_library`, a C++ library target that can be used as a dependency of a `nanobind_extension`. Directly forwards its arguments to the `cc_library` rule.
- `nanobind_test`, a C++ test for a `nanobind_library`. Forwards its argument to a `cc_test`.

Each target is given nanobind's specific build flags, optimizations and dependencies.

## Usage with bzlmod

This repo is published to the Bazel Central Registry (BCR). To use it, specify it as a `bazel_dep`:

```
# the major version is equal to the major version of the internally used nanobind.
bazel_dep(name = "nanobind_bazel", version = "1.0.0")
```

## Licenses and acknowledgements

This library is heavily inspired by the [pybind11-bazel](https://github.com/pybind/pybind11_bazel) project, which does the same thing for pybind11.
As I have used some of the code from that repository, its [license](pybind11_bazel.LICENSE) is included here, too.

In contrast to that project, though, nanobind does not support Python interpreter embedding, and endorses a few more size-related optimizations which I have included here.

## Roadmap

- [x] First successful test, e.g. on wjakob's [nanobind example](https://github.com/wjakob/nanobind_example).
- [x] A BCR release.
- [ ] A `nanobind_shared_library` target for a `cc_shared_library` using (lib)nanobind.
- [ ] Supporting custom nanobind build targets instead of the internal one.

## Contributing

I welcome all contributions.
If you encounter problems using these rules in your Bazel setup, please open an issue.
If you'd like to help maintain the project, write me a message.
