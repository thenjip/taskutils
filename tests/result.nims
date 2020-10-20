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
  proc test () =
    doAssertRaises(UnboxError):
      discard "abc".failure(int).unboxSuccess()

  test()


proc testUnboxFailure () =
  proc test () =
    doAssertRaises(UnboxError):
      discard "abc".success(int).unboxFailure()

  test()



proc main () =
  for test in [
    testMonadIdentity,
    testMonadRightIdentity,
    testMonadAssociativity,
    testUnboxSuccess,
    testUnboxFailure
  ]:
    test()



main()
