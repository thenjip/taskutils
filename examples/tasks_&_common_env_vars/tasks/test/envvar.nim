import backend
import ../common/[envvar]

import pkg/taskutils/[envtypes, filetypes, optional, parseenv, result]

import std/[strformat, sugar]



type
  EnvVar* {.pure.} = enum
    NimBackend
    OutDir



func name* (self: EnvVar): EnvVarName =
  const names: array[EnvVar, EnvVarName] = [
    nimBackend(),
    outDir()
  ]

  names[self]



func parseNimBackend* (envValue: EnvVarValue): ParseEnvResult[Backend] =
  func invalidValue (): ref ParseEnvError =
    EnvVar.NimBackend.name().parseEnvError(&"Invalid value: \"{envValue}\"")

  envVarValues()
    .findIndex(valid => envValue == valid)
    .ifSome(parseEnvSuccess, () => invalidValue.parseEnvFailure(Backend))


func parseOutDir* (envValue: EnvVarValue): ParseEnvResult[DirPath] =
  EnvVar.OutDir.name().parseDirPath(envValue)
