import pkg/taskutils/[envtypes, filetypes, parseenv, optional, result]

import std/[strutils, sugar]



type
  EnvVar* {.pure.} = enum
    OutDir



func name* (self: EnvVar): EnvVarName =
  const names: array[EnvVar, EnvVarName] = ["OUTDIR"]

  names[self]


func parseOutDir* (outDir: string): ParseEnvResult[DirPath] =
  func invalidPath (): ref ParseEnvError =
    EnvVar.OutDir.name().parseEnvError("Path is blank or empty.")

  outDir
    .some()
    .filter(s => not s.isEmptyOrWhitespace())
    .ifSome(parseEnvSuccess, () => invalidPath.parseEnvFailure(DirPath))
