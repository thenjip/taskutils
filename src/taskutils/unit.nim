type
  Unit* = tuple[]



func unit* (): Unit =
  ()


func ignore* [T](_: T) =
  discard
