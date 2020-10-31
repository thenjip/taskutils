import envtypes, filetypes, optional, parseenv, result

import std/[sugar]



func envNim* (): EnvVarName =
  ##[
    The name of the environment variable for the path to the Nim compiler.
  ]##
  "NIM"


func envNimFlags* (): EnvVarName =
  ##[
    The name of the environment variable for additional compiler options.
  ]##
  "NIMFLAGS"



func parseNim* (value: EnvVarValue): ParseEnvResult[FilePath] =
  ##[
    Does currently nothing other than returning a success.
  ]##
  value.parseEnvSuccess()


proc tryParseNim* (
  tryRead: EnvVarName -> Optional[EnvVarValue]
): Optional[ParseEnvResult[FilePath]] =
  envNim().tryRead().map(parseNim)



func parseNimFlags* (value: EnvVarValue): ParseEnvResult[string] =
  ##[
    Does currently nothing other than returning a success.
  ]##
  value.parseEnvSuccess()


proc tryParseNimFlags* (
  tryRead: EnvVarName -> Optional[EnvVarValue]
): Optional[ParseEnvResult[string]] =
  envNimFlags().tryRead().map(parseNimFlags)
