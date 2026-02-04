import os
import sys
from pathlib import Path
from typing import Union

from python.runfiles import runfiles
from stubgen import main

RLOCATION_ROOT = Path("_main")  # the Python path root under the script's runfiles.

r = runfiles.Create()


def get_bindir():
    """Obtain $BINDIR as an absolute path, from the current working directory."""
    ppath = Path.cwd()
    for p in ppath.parents:
        if p.parts[-1].endswith("bin"):
            return p
    raise RuntimeError("could not locate $(BINDIR)")


def convert_path_to_module(path: Union[str, os.PathLike]) -> str:
    """
    Converts a shared object file name to a Python module name
    understood by importlib.

    Example:
        For a shared lib pkg/foo.so, this returns pkg.foo.
    """
    pp = Path(path)
    # this trick strips up to two extensions from the file name.
    # Since possible extensions at this point are
    # .so, .abi3.so, and .pyd, this path always gives us the
    # name of the shared lib without any extension.
    extless = pp.with_name(pp.with_suffix("").stem)
    # TODO: Normalize to snakecase
    return ".".join(extless.parts)


def wrapper():
    """
    A small wrapper to convert nanobind extension targets to module names
    relative to the runfiles directory.

    nanobind's stubgen script can only deal with module names
    found on PYTHONPATH. Since Make variable expansion in Bazel
    only works for paths, this does us no good.

    The target extension and output file should be figured out directly
    from the user's nanobind_stubgen rule definition - in fact, making
    the user fiddle with rules is error-prone and unhelpful if they
    have no Bazel experience.

    Goes through the script's argv, finds the module name(s),
    and converts each of them to a valid Python 3 module name.
    """
    bindir = get_bindir()

    _, *args = sys.argv
    for i, arg in enumerate(args):
        if arg in ("-o", "-O", "-M"):
            # fix up file paths relative to $(BINDIR).
            args[i + 1] = str(bindir / args[i + 1])
        elif arg == "-m":
            fname = args[i + 1]
            if not fname.endswith((".so", ".pyd")):
                raise ValueError(
                    f"invalid extension file {fname!r}: "
                    "only shared object files with extensions "
                    ".so, .abi3.so, or .pyd are supported"
                )
            # the rlocation of the shared lib should always be
            # relative to bindir.
            modulepath = Path(r.Rlocation(fname)).relative_to(bindir)
            args[i + 1] = convert_path_to_module(modulepath)

    main(args)


if __name__ == "__main__":
    wrapper()
