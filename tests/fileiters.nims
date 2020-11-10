import taskutils/[fileiters, filetypes]

import std/[os, sequtils, sets, strformat, sugar]



func addNimExt (file: FilePath): FilePath =
  file.addFileExt(nimExt())



func rootDirName (): string =
  "fileiters"


func fooDirName (): string =
  "foo"


func rootDir (): RelativeDir =
  rootDirName()


func fooDir (): RelativeDir =
  rootDir() / fooDirName()



func rootNimModules (): seq[RelativeFile] =
  ["b", "c"].map(addNimExt)


func fooNimModules (): seq[RelativeFile] =
  ["b"].map(addNimExt)



proc testRelativeNimModules () =
  let
    expected = rootNimModules().toHashSet()
    actual =
      collect initHashSet(expected.len()):
        for module in rootDir().relativeNimModules():
          {module}

  doAssert(actual == expected)


proc testAbsoluteNimModules () =
  let
    expected =
      fooNimModules().map(f => fooDir() / f).toHashSet()
    actual =
      collect initHashSet(expected.len()):
        for module in fooDir().absoluteNimModules():
          {module}

  doAssert(actual == expected)


proc testRelativeNimModulesRec () =
  let
    expected =
      rootNimModules()
        .`&`(fooNimModules().map(f => fooDirName() / f))
        .toHashSet()
    actual =
      collect initHashSet(expected.len()):
        for module in rootDir().relativeNimModulesRec():
          {module}

  doAssert(expected == actual)


proc testAbsoluteNimModulesRec () =
  let
    expected =
      rootNimModules()
        .`&`(fooNimModules().map(f => fooDirName() / f))
        .map(f => rootDir() / f)
        .toHashSet()
    actual =
      collect initHashSet(expected.len()):
        for module in rootDir().absoluteNimModulesRec():
          {module}

  doAssert(expected == actual)



proc main () =
  for test in [
    testRelativeNimModules,
    testAbsoluteNimModules,
    testRelativeNimModulesRec,
    testAbsoluteNimModulesRec
  ]:
    test()



main()
