import "../foo.nimble"

import pkg/taskutils/[envtypes, optional, parseenv]

import std/[sugar]



export foo



func nimbleProjectName* (): string =
  "foo"



func findInEnv* (name: EnvVarName): Optional[EnvVarValue] =
  name.findValue(existsEnv, key => key.getEnv())
