import ../common/[envvar]

import pkg/taskutils/[envtypes, filetypes, parseenv]



type
  EnvVar* {.pure.} = enum
    OutDir



func name* (self: EnvVar): EnvVarName =
  const names: array[EnvVar, EnvVarName] = [outDir()]

  names[self]



func parseOutDir* (envValue: EnvVarValue): ParseEnvResult[DirPath] =
  EnvVar.OutDir.name().parseDirPath(envValue)
