"""
Build defs for nanobind.

The ``nanobind_extension`` corresponds to a ``cc_binary``,
the ``nanobind_library`` to a ``cc_library``,
the ``nanobind_shared_library`` to a ``cc_shared_library``,
the ``nanobind_static_library`` to a ``cc_static_library``,
the ``nanobind_stubgen`` to a ``py_binary``,
and the ``nanobind_test`` to a ``cc_test``.

For creating Python bindings, the most likely case is a ``nanobind_extension``
built using the C++ source files containing the nanobind module definition,
which can then be included e.g. as a `data` input in a ``py_library``.
"""

load("@bazel_skylib//rules:copy_file.bzl", "copy_file")
load(
    "@nanobind_bazel//:helpers.bzl",
    "extension_name",
    "nb_common_opts",
    "nb_sizeopts",
)
load("@rules_cc//cc:cc_shared_library.bzl", "cc_shared_library")
load("@rules_cc//cc:defs.bzl", "cc_binary", "cc_library", "cc_test")
load("@rules_python//python:py_binary.bzl", "py_binary")

NANOBIND_COPTS = nb_common_opts() + nb_sizeopts()
NANOBIND_STATIC = [Label("@nanobind//:nanobind")]
NANOBIND_SHARED = [Label("@nanobind//:nanobind_shared")]
LIBNANOBIND = [Label("@nanobind//:libnanobind")]

def nanobind_extension(
        name,
        domain = "",
        srcs = [],
        copts = [],
        deps = [],
        dynamic_deps = [],
        linkstatic = True,
        nanobind_link_mode = "auto",
        local_defines = [],
        **kwargs):
    """A C++ Python extension library built with nanobind.

    Given a name $NAME, defines the following targets:
    1. $NAME.so, a shared object library for use on Linux/Mac.
    2. $NAME.abi3.so, a copy of $NAME.so for Linux/Mac,
        indicating that it is compatible with the Python stable ABI.
    3. $NAME.pyd, a copy of $NAME.so for use on Windows.
    4. $NAME, an alias pointing to the appropriate library
        depending on the target platform.

    Args:
        name: str
            A name for this target. This becomes the Python module name
            used by the resulting nanobind extension.
        domain: str, default ''
            The nanobind domain to set for this extension. A nanobind domain is
            an optional attribute that can be set to scope extension code to a named
            domain, which avoids conflicts with other extensions.
        srcs: list
            A list of sources and headers to go into this target.
        copts: list
            A list of compiler optimizations. Augmented with nanobind-specific
            compiler optimizations by default.
        deps: list
            A list of dependencies of this extension.
        dynamic_deps: list
            A list of shared library dependencies of the extension.
            Augmented by `libnanobind.so` if linkstatic is set to `False`, or if
            `nanobind_link_mode = "shared"`.
        linkstatic: bool
            Whether to link the extension in static mode.
            Additionally, setting this to `False` means the library will be linked
            against `libnanobind.so`.
        nanobind_link_mode: str, either "static", "shared", or "auto"
            Linkage to request for (lib)nanobind. Can either be "static" to link nanobind
            statically, "shared" to link against `libnanobind.so`, or "auto", which decides
            linkage based on the value of `linkstatic` (see above).
        local_defines: list
            A list of preprocessor defines to set for this target.
            Augmented with `-DNB_DOMAIN=$DOMAIN` if the domain argument is given.
        **kwargs: Any
            Keyword arguments matching the `cc_binary` rule arguments, to be passed
            directly to the resulting `cc_binary` target.
    """
    if domain != "":
        NANOBIND_DOMAIN = ["NB_DOMAIN={}".format(domain)]
    else:
        NANOBIND_DOMAIN = []

    if nanobind_link_mode not in ("static", "shared", "auto"):
        fail("nanobind_linkage has to be one of 'static', 'shared', or 'auto'")

    if nanobind_link_mode == "auto":
        nb_linkstatic = linkstatic
    else:
        nb_linkstatic = True if nanobind_link_mode == "static" else False

    NANOBIND = NANOBIND_STATIC if nb_linkstatic else NANOBIND_SHARED
    NB_DYNDEPS = LIBNANOBIND if not nb_linkstatic else []

    cc_binary(
        name = name + ".so",
        srcs = srcs,
        copts = copts + NANOBIND_COPTS,
        deps = deps + NANOBIND,
        local_defines = local_defines + NANOBIND_DOMAIN,
        linkshared = True,  # Python extensions need to be shared libs.
        linkstatic = linkstatic,
        dynamic_deps = dynamic_deps + NB_DYNDEPS,
        **kwargs
    )

    copy_file(
        name = name + "_copy_so_to_abi3_so",
        src = name + ".so",
        out = name + ".abi3.so",
        testonly = kwargs.get("testonly"),
        visibility = kwargs.get("visibility"),
    )

    copy_file(
        name = name + "_copy_so_to_pyd",
        src = name + ".so",
        out = name + ".pyd",
        testonly = kwargs.get("testonly"),
        visibility = kwargs.get("visibility"),
    )

    native.alias(
        name = name,
        actual = extension_name(name),
        testonly = kwargs.get("testonly"),
        visibility = kwargs.get("visibility"),
    )

def nanobind_library(
        name,
        copts = [],
        deps = [],
        linkstatic = False,
        nanobind_link_mode = "auto",
        **kwargs):
    """A static or shared library depending on nanobind.

    Args:
        name: str
            A name for this target. This becomes the C++ library name.
        copts: list
            A list of compiler optimizations. Augmented with nanobind-specific
            compiler optimizations by default.
        deps: list
            A list of dependencies of this extension.
        linkstatic: bool
            Whether to link the extension in static mode.
            Additionally, setting this to `False` means the library will be linked
            against a shared version of `@nanobind`.
        nanobind_link_mode: str, either "static", "shared", or "auto"
            Linkage to request for (lib)nanobind. Can either be "static" to link nanobind
            statically, "shared" to link against `libnanobind.so`, or "auto", which decides
            linkage based on the value of `linkstatic` (see above).
        **kwargs: Any
            Keyword arguments matching the `cc_library` rule arguments, to be passed
            directly to the resulting `cc_library` target.
    """

    if nanobind_link_mode not in ("static", "shared", "auto"):
        fail("nanobind_linkage has to be one of 'static', 'shared', or 'auto'")

    if nanobind_link_mode == "auto":
        nb_linkstatic = linkstatic
    else:
        nb_linkstatic = True if nanobind_link_mode == "static" else False

    NANOBIND = NANOBIND_STATIC if nb_linkstatic else NANOBIND_SHARED

    cc_library(
        name = name,
        copts = copts + NANOBIND_COPTS,
        deps = deps + NANOBIND,
        linkstatic = linkstatic,
        **kwargs
    )

def nanobind_shared_library(
        name,
        deps = [],
        **kwargs):
    """A shared library containing nanobind as a static dependency.

    Using a shared nanobind library is useful when partitioning C++ binding
    code over multiple extensions, where linking all of them statically would
    produce much larger bindings than necessary.

    Args:
        name: str
            A name for this target. On Linux/MacOS, the target name determines
            the name of the resulting shared object file via lib${name}.so, e.g.
            a `cc_shared_library(name = "nanobind-tensorflow")` produces the
            shared object file libnanobind-tensorflow.so.
        deps: list
            A list of static dependencies for this shared library. By default,
            a statically built nanobind is included.
        **kwargs: Any
            Additional keyword arguments passed directly to the `cc_shared_library`
            rule. For a comprehensive list, see the Bazel documentation at
            https://bazel.build/reference/be/c-cpp#cc_shared_library.
    """
    cc_shared_library(
        name = name,
        deps = deps + NANOBIND_STATIC,
        **kwargs
    )

def nanobind_static_library(
        name,
        deps = [],
        **kwargs):
    """A single static library with nanobind as a static dependency.

    Requires Bazel 7.4.0 or greater to use, as well as setting the
    `--experimental_cc_static_library` flag for the build.

    Args:
    name: str
        A name for this target.
    deps: list
        A list of dependencies for this static library. By default,
        a statically built nanobind is included.
    **kwargs: Any
        Additional keyword arguments to be passed directly to the
        `native.cc_static_library` rule.
        For a comprehensive list, see the Bazel documentation at
        https://bazel.build/reference/be/c-cpp#cc_static_library.
    """
    if "cc_static_library" not in dir(native):
        fail("`nanobind_static_library` requires Bazel 7.4.0 or newer")

    # TODO(nicholasjng): Source this from rules_cc once it graduates
    # out of experimental status, or once the minimum required rules_cc
    # version is recent enough, see
    # https://github.com/bazelbuild/rules_cc/commit/b1c049c65c7ffa4dfa175e29b6af75d5e08486d5.
    native.cc_static_library(name = name, deps = deps + NANOBIND_STATIC, **kwargs)

def nanobind_stubgen(
        name,
        module,
        output_file = None,
        output_directory = None,
        imports = [],
        pattern_file = None,
        marker_file = None,
        include_private_members = False,
        exclude_docstrings = False,
        exclude_values = False,
        quiet = False,
        recursive = False):
    """Creates a stub file containing Python type annotations for a nanobind extension.

    Args:
        name: str
            Name of this stub generation target, unused.
        module: Label
            Label of the extension module for which the stub file should be
            generated.
        output_file: str or None
            Output file path for the generated stub, relative to $(BINDIR).
            If none is given, the stub will be placed under the same location
            as the module in your source tree.
        output_directory: str or None
            Output directory for the generated stub, relative to $(BINDIR).
            If none is given, the stub will be placed under the same location
            as the module in your source tree.
        imports: list
            List of modules to import for stub generation.
        pattern_file: Label or None
            Label of a pattern file used for programmatically editing generated stubs.
            For more information, consider the documentation under
            https://nanobind.readthedocs.io/en/latest/typing.html#pattern-files.
        marker_file: str or None
            An empty typing marker file to add to the project, most often named
            "py.typed". Must be given relative to your Python project root.
        include_private_members: bool
            Whether to include private module members, i.e. those starting and/or
            ending with an underscore ("_").
        exclude_docstrings: bool
            Whether to exclude all docstrings of all module members from the generated
            stub file.
        exclude_values: bool
            Whether to replace all constants with a Python ellipsis placeholder.
        quiet: bool
            Whether to suppress output of the stubgen script.
        recursive: bool
            Whether to perform stub generation on submodules as well.
    """
    STUBGEN_WRAPPER = Label("@nanobind_bazel//:stubgen_wrapper.py")
    loc = "$(rlocationpath {})"

    # stubgen wrapper dependencies: nanobind.stubgen, typing_extensions (via nanobind),
    # rules_python runfiles (unused, needed later when giving an explicit output path)
    deps = [
        Label("@nanobind//:stubgen"),
        Label("@pypi__typing_extensions//:lib"),
        Label("@rules_python//python/runfiles"),
    ]

    data = [module]

    args = ["-m " + loc.format(module)]

    if recursive and output_file:
        fail("Cannot specify an output file if recursive stubgen is requested")

    if recursive and not output_directory:
        fail("Must specify an output directory for recursive stubgen")

    if recursive:
        args.append("-r")

    if output_directory:
        args.append("-O {}".format(output_directory))

    # to be searchable by path expansion, a file must be
    # declared by a rule beforehand. This might not be the
    # case for a generated stub, so we just give the raw name here
    if output_file:
        args.append("-o {}".format(output_file))

    # Add pattern and marker files.
    # The pattern file must exist in the Bazel repo, so
    # we pass its label to the py_binary's data dependencies.
    # The marker file can be generated on the fly, however.
    if pattern_file:
        data.append(pattern_file)
        args.append("-p " + loc.format(pattern_file))
    if marker_file:
        args.append("-M {}".format(marker_file))

    if include_private_members:
        args.append("--include-private")
    if exclude_docstrings:
        args.append("--exclude-docstrings")
    if exclude_values:
        args.append("--exclude-values")
    if quiet:
        args.append("-q")

    py_binary(
        name = name,
        srcs = [STUBGEN_WRAPPER],
        main = STUBGEN_WRAPPER,
        deps = deps,
        data = data,
        imports = imports,
        args = args,
    )

def nanobind_test(
        name,
        copts = [],
        deps = [],
        dynamic_deps = [],
        linkstatic = False,
        nanobind_link_mode = "auto",
        **kwargs):
    """A C++ test depending on nanobind.

    Args:
        name: str
            A name for this target. This becomes the Python module name
            used by the resulting nanobind extension.
        copts: list
            A list of compiler optimizations. Augmented with nanobind-specific
            compiler optimizations by default.
        deps: list
            A list of dependencies of this extension.
        dynamic_deps: list
            A list of shared library dependencies of the extension.
            Augmented by `libnanobind.so` if linkstatic is set to `False`, or if
            `nanobind_link_mode = "shared"`.
        linkstatic: bool
            Whether to link the extension in static mode.
            Additionally, setting this to `False` means the library will be linked
            against `libnanobind.so`.
        nanobind_link_mode: str, either "static", "shared", or "auto"
            Linkage to request for (lib)nanobind. Can either be "static" to link nanobind
            statically, "shared" to link against `libnanobind.so`, or "auto", which decides
            linkage based on the value of `linkstatic` (see above).
        **kwargs: Any
            Keyword arguments matching the `cc_test` rule arguments, to be passed
            directly to the resulting `cc_test` target.
    """

    if nanobind_link_mode not in ("static", "shared", "auto"):
        fail("nanobind_linkage has to be one of 'static', 'shared', or 'auto'")

    if nanobind_link_mode == "auto":
        nb_linkstatic = linkstatic
    else:
        nb_linkstatic = True if nanobind_link_mode == "static" else False

    NANOBIND = NANOBIND_STATIC if nb_linkstatic else NANOBIND_SHARED
    NB_DYNDEPS = LIBNANOBIND if not nb_linkstatic else []
    cc_test(
        name = name,
        copts = copts + NANOBIND_COPTS,
        deps = deps + NANOBIND,
        dynamic_deps = dynamic_deps + NB_DYNDEPS,
        **kwargs
    )
