import std/[options, sugar]



export options



type
  Optional* [T] = Option[T]



proc ifSome* [A; B](self: Optional[A]; then: A -> B; `else`: () -> B): B =
  if self.isSome():
    self.unsafeGet().then()
  else:
    `else`()


proc ifNone* [A; B](self: Optional[A]; then: () -> B; `else`: A -> B): B =
  self.ifSome(`else`, then)



func getOr* [T](self: Optional[T]; `else`: () -> T): T =
  self.ifSome(val => val, `else`)
