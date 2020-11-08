import backend, envvar
import ../common/["env.nims"]

import pkg/taskutils/[filetypes, optional, parseenv]



export backend, env, envvar



func tryParseNimBackend* (): Optional[ParseEnvResult[Backend]] =
  EnvVar.NimBackend.name().tryParseEnv(parseNimBackend)


func tryParseOutDir* (): Optional[ParseEnvResult[DirPath]] =
  EnvVar.OutDir.name().tryParseEnv(parseOutDir)
