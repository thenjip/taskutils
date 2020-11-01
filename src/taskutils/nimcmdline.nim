import std/[os, sequtils, strformat, sugar]



type
  OptionName* = string
  OptionValue* = string



func nimLongOptionPrefix* (): string =
  ##[
    Since 0.2.0.
  ]##
  "--"


func longOptionPrefix* (): string {.deprecated.} =
  ##[
    Deprecated since 0.2.0.
    Use `nimLongOptionPrefix` instead.
  ]##
  nimLongOptionPrefix()



func nimLongOption* (name: OptionName): string =
  ##[
    Since 0.2.0.
  ]##
  fmt"{nimLongOptionPrefix()}{name}"


func longOption* (name: OptionName): string {.deprecated.} =
  ##[
    Deprecated since 0.2.0.
    Use `nimLongOption` instead.
  ]##
  name.nimLongOption()


func nimLongOption* (name: OptionName, value: OptionValue): string =
  ##[
    Since 0.2.0.
  ]##
  fmt"{name.nimLongOption()}:{value.quoteShell()}"


func longOption* (name: OptionName, value: OptionValue): string {.deprecated.} =
  ##[
    Deprecated since 0.2.0.
    Use `nimLongOption` instead.
  ]##
  name.nimLongOption(value)



func toNimLongOptions* (options: varargs[OptionName]): seq[string] =
  options.map(name => name.nimLongOption())


func toNimLongOptions* (
  options: varargs[tuple[name: OptionName, value: OptionValue]]
): seq[string] =
  options.map(opt => opt.name.nimLongOption(opt.value))
