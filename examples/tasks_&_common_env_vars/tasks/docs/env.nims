import envvar
import ../common/["env.nims"]

import pkg/taskutils/[filetypes, optional, parseenv]



export env, envvar



func tryParseOutDir* (): Optional[ParseEnvResult[DirPath]] =
  EnvVar.OutDir.name().tryParseEnv(parseOutDir)
