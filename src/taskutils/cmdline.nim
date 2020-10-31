import std/[strutils]



func cmdLine* (parts: varargs[string]): string =
  parts.join($' ')
