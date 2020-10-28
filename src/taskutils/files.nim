import filetypes, optional

import std/[os]



proc exeExists* (exe: FilePath): bool =
  ##[
    Checks whether the executable `exe` exists.

    Returns true if at least one of the following conditions is satisfied:
      - `exe` is a path leading to an existing file.
      - `exe` exists in the current workind directory.
      - `exe` exists in the PATH.

    Symlinks are followed.
  ]##
  exe.findExe().len() > 0


proc findExec* (exe: FilePath): Optional[FilePath] =
  ##[
    It is the same as `os.findExe<https://nim-lang.org/docs/os.html#findExe%2Cstring%2Cbool%2CopenArray%5Bstring%5D>`_,
    but it returns an `Optional`.
  ]##
  if exe.exeExists():
    exe.some()
  else:
    result.boxedType().none()
