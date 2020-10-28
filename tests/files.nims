import taskutils/[files, filetypes, optional]

import std/[os]



proc dataDir (): AbsoluteDir =
  getCurrentDir() / "files"



proc testExeExists () =
  proc testExists (exe: FilePath) =
    doAssert(exe.exeExists())

  proc testNotExists (exe: FilePath) =
    doAssert(not exe.exeExists())

  testExists("nim")
  testNotExists(dataDir() / "nim")


proc testFindExec () =
  proc testFound (exe: FilePath) =
    let
      expected = exe.some()
      actual = exe.findExec()

    doAssert(actual == expected)

  proc testNotFound (exe: FilePath) =
    let
      expected = exe.typeof().none()
      actual = exe.findExec()

    doAssert(actual == expected)

  testFound("nim")
  testNotFound(dataDir() / "nim")



proc main () =
  for test in [
    testExeExists,
    testFindExec
  ]:
    test()



main()
