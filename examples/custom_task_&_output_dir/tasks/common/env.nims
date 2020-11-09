import pkg/taskutils/[envtypes, optional, parseenv]

import std/[sugar]



func findInEnv* (name: EnvVarName): Optional[EnvVarValue] =
  name.findValue(existsEnv, key => key.getEnv())
