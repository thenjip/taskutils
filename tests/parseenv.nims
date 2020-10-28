import taskutils/[envtypes, optional, parseenv]

import std/[sugar, tables]



proc testFindValue () =
  proc testFound (
    name: EnvVarName;
    exists: EnvVarName -> bool;
    read: EnvVarName -> EnvVarValue
  ) =
    let
      expected = name.read().some()
      actual = name.findValue(exists, read)

    doAssert(actual == expected)

  proc testNotFound (
    name: EnvVarName;
    exists: EnvVarName -> bool;
    read: EnvVarName -> EnvVarValue
  ) =
    let
      expected = EnvVarValue.none()
      actual = name.findValue(exists, read)

    doAssert(actual == expected)

  proc testFoundInTable (name: EnvVarName; value: EnvVarValue) =
    let table = {name: value}.toTable()

    name.testFound(name => name in table, name => table[name])

  proc testNotFoundInTable (name: EnvVarName) =
    let table = {name & "a": "abc"}.toTable()

    name.testNotFound(name => name in table, name => table[name])

  testFoundInTable("ABC", "abc")
  testNotFoundInTable("aBc")



proc main () =
  for test in [
    testFindValue
  ]:
    test()



main()
