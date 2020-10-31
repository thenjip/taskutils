import taskutils/[envtypes, envvars, filetypes, parseenv, optional, result]

import std/[os, strutils, sugar, tables]



func findValue [K; V](self: Table[K, V]; key: K): Optional[V] =
  if key in self:
    self[key].some()
  else:
    V.none()



proc testTryParseNim () =
  proc testValid (value: EnvVarValue) =
    let
      env = {envNim(): value}.toTable()
      expected = value.parseEnvSuccess()
      actual = tryParseNim(key => env.findValue(key)).get()

    doAssert(actual == expected)

  proc testNotFound () =
    let
      env = {"ABC": "abc"}.toTable()
      expected = ParseEnvResult[FilePath].none()
      actual = tryParseNim(key => env.findValue(key))

    doAssert(actual == expected)

  testValid("nim")
  testValid("usr" / "bin" / "nim")
  testNotFound()


proc testTryParseNimFlags () =
  proc testValid (value: EnvVarValue) =
    let
      env = {envNimFlags(): value}.toTable()
      expected = value.parseEnvSuccess()
      actual = tryParseNimFlags(key => env.findValue(key)).get()

    doAssert(actual == expected)

  proc testNotFound () =
    let
      env = {"ABC": "abc"}.toTable()
      expected = ParseEnvResult[string].none()
      actual = tryParseNimFlags(key => env.findValue(key))

    doAssert(actual == expected)

  testValid("-d:nodejs")
  testValid(["--opt:speed", "--stackTrace:off", "-f"].join($' '))
  testNotFound()



proc main () =
  for test in [
    testTryParseNim,
    testTryParseNimFlags
  ]:
    test()



main()
