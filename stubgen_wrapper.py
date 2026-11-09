import os
import sys
from pathlib import Path
from typing import Union

from stubgen import main


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
    _, *args = sys.argv
    stub_out = None
    for i, arg in enumerate(args):
        if arg == "-m":
            fname = args[i + 1]
            if not fname.endswith((".so", ".pyd")):
                raise ValueError(
                    f"invalid extension file {fname!r}: "
                    "only shared object files with extensions "
                    ".so, .abi3.so, .abi3t.so, or .pyd are supported"
                )


            modulepath = Path(fname)
            modulename = modulepath.with_suffix("").stem # Get the name of the module
            args[i + 1] = modulename

            # Add the path to the runfiles directory to the PYTHONPATH, so we can import it directly
            sys.path.insert(0, modulepath.parent.as_posix())

            if "-o" not in args and "-O" not in args:
                modname = modulepath.with_suffix("").stem
                stub_out = str((modulepath).with_name(modname + ".pyi"))

    if stub_out is not None:
        args.extend(["-o", stub_out])

    main(args)


if __name__ == "__main__":
    wrapper()
