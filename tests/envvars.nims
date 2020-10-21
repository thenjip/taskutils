import taskutils/[envtypes, envvars, parseenv, optional, result]

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
      expected = value.success(() -> ref ParseEnvError)
      actual = tryParseNim(key => env.findValue(key)).get()

    doAssert(actual == expected)

  proc testInvalid (value: EnvVarValue) =
    let
      env = {envNim(): value}.toTable()
      result = tryParseNim(key => env.findValue(key)).get()

    doAssert(result.isFailure())

  testValid("nim")
  testValid("usr" / "bin" / "nim")
  testInvalid("home" / "user" / ".local" / "bin" / "nim.")


proc testTryParseNimFlags () =
  proc testValid (value: EnvVarValue) =
    let
      env = {envNimFlags(): value}.toTable()
      expected = value.success(() -> ref ParseEnvError)
      actual = tryParseNimFlags(key => env.findValue(key)).get()

    doAssert(actual == expected)

  testValid("-d:nodejs")
  testValid(["--opt:speed", "--stackTrace:off", "-f"].join($' '))



proc main () =
  for test in [
    testTryParseNim,
    testTryParseNimFlags
  ]:
    test()



main()
