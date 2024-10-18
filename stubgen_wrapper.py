import os
import sys

from pathlib import Path
from typing import Union

from stubgen import main

DEBUG = bool(os.getenv("DEBUG"))
RLOCATION_ROOT = Path("_main")  # the Python path root under the script's runfiles.

def get_runfiles_dir(path: Union[str, os.PathLike]):
    """Obtain the runfiles root from the Python script path."""
    ppath = Path(path)
    for p in ppath.parents:
        if p.parts[-1].endswith("runfiles"):
            return p
    raise RuntimeError("could not locate runfiles directory")


def get_bindir(path: Union[str, os.PathLike]):
    """Obtain $(BINDIR) as an absolute path, from the current working directory.

    NB: runfiles are not necessarily in the build tree on Windows,
    so this needs to be deduced from the CWD of the script.
    """
    ppath = Path(path)
    for p in ppath.parents:
        if p.parts[-1].endswith("bin"):
            return p
    raise RuntimeError("could not locate $(BINDIR)")


def convert_path_to_module(path: Union[str, os.PathLike]):
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
    script, *args = sys.argv
    runfiles_dir = get_runfiles_dir(script)
    bindir = get_bindir(os.getcwd())
    if DEBUG:
        print(f"runfiles_dir = {runfiles_dir}")
        print(f"bindir = {bindir}")
    fname = ""
    for i, arg in enumerate(args):
       if arg.startswith("-m"):
           fname = args.pop(i + 1)
           if not fname.endswith((".so", ".pyd")):
               raise ValueError(
                   f"invalid extension file {fname!r}: "
                   "only shared object files with extensions "
                   ".so, .abi3.so, or .pyd are supported"
               )
           modname = convert_path_to_module(fname)
           args.insert(i + 1, modname)

    if "-o" not in args:
        ext_path = runfiles_dir / fname
        if DEBUG:
            print(f"ext_path = {ext_path}")
        if ext_path.is_symlink():
            # Path.readlink() is available on Python 3.9+ only.
            objfile = Path(os.readlink(ext_path))
        else:
            objfile = bindir / Path(fname).relative_to(RLOCATION_ROOT)
            if not objfile.exists():
                raise RuntimeError("could not locate original path to object file")

        stub_outpath = objfile.with_suffix("").with_suffix(".pyi")
        if DEBUG:
            print(f"stub_outpath = {stub_outpath}")

        args.extend(["-o", str(stub_outpath)])
    else:
        # we have an output file, use its path instead relative to $(BINDIR),
        # but in absolute form.
        idx = args.index("-o")
        args[idx + 1] = str(bindir / args[idx + 1])

    if "-M" in args:
        # fix up the path to the marker file relative to $(BINDIR).
        idx = args.index("-M")
        args[idx + 1] = str(bindir / args[idx + 1])

    main(args)


if __name__ == "__main__":
    wrapper()
