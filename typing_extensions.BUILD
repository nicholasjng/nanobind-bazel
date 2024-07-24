"""
A version of the Python sdist Bazel template found in
https://github.com/bazelbuild/rules_python/blob/main/python/private/pypi/deps.bzl ,
specialized on the ``typing_extensions`` package.

# Copyright 2023 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""

load("@rules_python//python:defs.bzl", "py_library")

package(default_visibility = ["//visibility:public"])

py_library(
    name = "lib",
    srcs = ["src/typing_extensions.py"],
    data = [
        "CHANGELOG.md",
        "LICENSE",
        "PKG-INFO",
        "README.md",
        "pyproject.toml",
    ],
    # This makes the source directory a top-level in the Python import
    # search path for anything that depends on this.
    imports = ["src"],
)
