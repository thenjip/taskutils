import filetypes

import std/[os, strutils]



func nimExt* (): string =
  "nim"


func nimsExt* (): string =
  "nims"



iterator files* (dir: DirPath; ext: string; relative: bool): FilePath =
  ##[
    Yields the files in the directory `dir` with the extension `ext`.

    `ext` should not include the separator.
    Symlinks are not followed.
  ]##
  for kind, file in dir.walkDir(relative = relative):
    if kind == pcFile and file.endsWith(ExtSep & ext):
      yield file


iterator relativeFiles* (dir: DirPath; ext: string): RelativeFile =
  ##[
    Yields the files in the directory `dir` with the extension `ext`.
    The yielded paths are relative.

    `ext` should not include the separator.
    Symlinks are not followed.
  ]##
  for file in dir.files(ext, relative = true):
    yield file


iterator absoluteFiles* (dir: DirPath; ext: string): AbsoluteFile =
  ##[
    Yields the files in the directory `dir` with the extension `ext`.
    The yielded paths are absolute.

    `ext` should not include the separator.
    Symlinks are not followed.
  ]##
  for file in dir.files(ext, relative = false):
    yield getCurrentDir() / file



iterator filesRec* (dir: DirPath; ext: string; relative: bool): FilePath =
  ##[
    Recursively iterates on the files in the directory `dir` with the extension
    `ext`.

    `ext` should not include the separator.
    Symlinks are not followed.
  ]##
  for file in dir.walkDirRec(relative = relative):
    if file.endsWith(ExtSep & ext):
      yield file


iterator relativeFilesRec* (dir: DirPath; ext: string): RelativeFile =
  ##[
    Recursively iterates on the files in the directory `dir` with the extension
    `ext`.
    The yielded paths are relative to `dir`.

    `ext` should not include the separator.
    Symlinks are not followed.
  ]##
  for file in dir.filesRec(ext, true):
    yield file


iterator absoluteFilesRec* (dir: DirPath; ext: string): AbsoluteFile =
  ##[
    Recursively iterates on the files in the directory `dir` with the extension
    `ext`.
    The yielded paths are absolute.

    `ext` should not include the separator.
    Symlinks are not followed.
  ]##
  for file in dir.filesRec(ext, false):
    yield getCurrentDir() / file



iterator relativeNimModules* (dir: DirPath): RelativeFile =
  ##[
    Yields the Nim modules in the directory `dir`.
    The yielded paths are relative to `dir`.

    Symlinks are not followed.
  ]##
  for file in dir.relativeFiles(nimExt()):
    yield file


iterator absoluteNimModules* (dir: DirPath): AbsoluteFile =
  ##[
    Yields the Nim modules in the directory `dir`.
    The yielded paths are absolute.

    Symlinks are not followed.
  ]##
  for file in dir.absoluteFiles(nimExt()):
    yield file


iterator relativeNimModulesRec* (dir: DirPath): RelativeFile =
  ##[
    Recursively iterates on the Nim modules in the directory `dir`.
    The yielded paths are relative to `dir`.

    Symlinks are not followed.
  ]##
  for file in dir.relativeFilesRec(nimExt()):
    yield file


iterator absoluteNimModulesRec* (dir: DirPath): AbsoluteDir =
  ##[
    Recursively iterates on the Nim modules in the directory `dir`.
    The yielded paths are absolute.

    Symlinks are not followed.
  ]##
  for file in dir.absoluteFilesRec(nimExt()):
    yield file



iterator relativeNimsModules* (dir: DirPath): RelativeFile =
  ##[
    Yields the NimScript modules in the directory `dir`.
    The yielded paths are relative to `dir`.

    Symlinks are not followed.
  ]##
  for file in dir.relativeFiles(nimsExt()):
    yield file


iterator absoluteNimsModules* (dir: DirPath): AbsoluteFile =
  ##[
    Yields the NimScript modules in the directory `dir`.
    The yielded paths are absolute.

    Symlinks are not followed.
  ]##
  for file in dir.absoluteFiles(nimsExt()):
    yield file


iterator relativeNimsModulesRec* (dir: DirPath): RelativeFile =
  ##[
    Recursively iterates on the NimScript modules in the directory `dir`.
    The yielded paths are relative to `dir`.

    Symlinks are not followed.
  ]##
  for file in dir.relativeFilesRec(nimsExt()):
    yield file


iterator absoluteNimsModulesRec* (dir: DirPath): AbsoluteDir =
  ##[
    Recursively iterates on the NimScript modules in the directory `dir`.
    The yielded paths are absolute.

    Symlinks are not followed.
  ]##
  for file in dir.absoluteFilesRec(nimsExt()):
    yield file
