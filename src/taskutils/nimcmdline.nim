import std/[os, sequtils, strformat, sugar]



type
  OptionName* = string
  OptionValue* = string



func longOptionPrefix* (): string =
  "--"


func longOption* (name: OptionName): string =
  fmt"{longOptionPrefix()}{name}"


func longOption* (name: OptionName, value: OptionValue): string =
  fmt"{name.longOption()}:{value.quoteShell()}"



func toNimLongOptions* (options: openArray[OptionName]): seq[string] =
  options.map(name => name.longOption())


func toNimLongOptions* (
  options: openArray[tuple[name: OptionName, value: OptionValue]]
): seq[string] =
  options.map(opt => opt.name.longOption(opt.value))
