import taskutils/[optional]

import std/[sugar]



proc testIfSome () =
  doAssert(0.some().ifSome(i => i, () => 1) == 0)
  doAssert(char.none().ifSome(_ => _, () => 'b') == 'b')


proc testIfNone () =
  doAssert("abc".some().ifNone(() => "", s => s) == "abc")
  doAssert(pointer.none().ifNone(() => nil.pointer, _ => _) == nil)


proc testGetOr () =
  doAssert(0.some().getOr(() => 1) == 0)
  doAssert(int8.none().getOr(() => 1) == 1)



proc main () =
  for test in [
    testIfSome,
    testIfNone,
    testGetOr
  ]:
    test()



main()
