import taskutils/[result]

import std/[sugar]



proc testMonadIdentity () =
  proc test [A; B; F](initial: A; f: A -> Result[B, F]) =
    let
      expected = f(initial)
      actual = initial.success(F).flatMap(f)

    doAssert(actual == expected)

  test(0, (i: int) => success($i, () -> ref IndexDefect))


proc testMonadRightIdentity () =
  proc test [S; F](initial: S) =
    let
      expected = initial.success(F)
      actual = expected.flatMap((s: S) => s.success(F))

    doAssert(actual == expected)

  test[string, int]("abc")


proc testMonadAssociativity () =
  proc test [A; B; C; F](
    initial: Result[A, F];
    f: A -> Result[B, F];
    g: B -> Result[C, F]
  ) =
    let
      expected = initial.flatMap((a: A) => a.f().flatMap(g))
      actual = initial.flatMap(f).flatMap(g)

    doAssert(actual == expected)

  test(
    'a'.success(Natural),
    (c: char) => c.`$`().success(Natural),
    (s: string) => s.len().success(Natural)
  )
  test(
    "abc".failure(int),
    (i: int) => i.float.success(string),
    (f: float) => f.`$`().success(string)
  )


proc testUnboxSuccess () =
  proc testSuccess [S](expected: S; F: typedesc) =
    let actual = expected.success(F).unboxSuccess()

    doAssert(actual == expected)

  proc testFailure [F](error: F; S: typedesc) =
    doAssertRaises UnboxError:
      discard error.failure(S).unboxSuccess()

  testSuccess(1, ref byte)
  testFailure("abc", int)
  testFailure(IOError.newException("abc"), char)


proc testUnboxSuccessOrRaise () =
  proc testSuccess [S](expected: S; E: typedesc[CatchableError]) =
    let actual = expected.success(ref E).unboxSuccessOrRaise()

    doAssert(actual == expected)

  proc testFailure [E: CatchableError](error: ref E; S: typedesc) =
    doAssertRaises error.typeof():
      discard error.failure(S).unboxSuccessOrRaise()

  testSuccess(-5i16, LibraryError)
  testFailure(IOError.newException("abc"), char)
  testFailure(ResourceExhaustedError.newException("abc"), Natural)


proc testUnboxFailure () =
  proc testSuccess [S](value: S; F: typedesc) =
    doAssertRaises UnboxError:
      discard value.success(F).unboxFailure()

  proc testFailure [F](expected: F; S: typedesc) =
    let actual = expected.failure(S).unboxFailure()

    doAssert(actual == expected)

  testSuccess(1, ref byte)
  testFailure("abc", int)
  testFailure(IOError.newException("abc"), char)



proc main () =
  for test in [
    testMonadIdentity,
    testMonadRightIdentity,
    testMonadAssociativity,
    testUnboxSuccess,
    testUnboxSuccessOrRaise,
    testUnboxFailure
  ]:
    test()



main()
