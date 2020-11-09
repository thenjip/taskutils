import pkg/taskutils/[envtypes]



type
  Backend* {.pure.} = enum
    C
    Cxx
    Objc
    Js



func envVarValues* (): array[Backend, EnvVarValue] =
  const values: array[Backend, EnvVarValue] = [
    "c",
    "cxx",
    "objc",
    "js"
  ]

  values


func envVarValue* (self: Backend): string =
  envVarValues()[self]


func nimCmd* (self: Backend): string =
  const cmds: array[Backend, result.typeof()] = [
    "cc",
    "cpp",
    "objc",
    "js"
  ]

  cmds[self]
