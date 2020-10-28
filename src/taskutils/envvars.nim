import envtypes, filetypes, optional, parseenv, result

import std/[sugar]



func envNim* (): string =
  ##[
    The name of the environment variable for the path to the Nim compiler.
  ]##
  "NIM"


func envNimFlags* (): string =
  ##[
    The name of the environment variable for additional compiler options.
  ]##
  "NIMFLAGS"



func parseNim* (value: EnvVarValue): Result[FilePath, () -> ref ParseEnvError] =
  ##[
    Does currently nothing other than returning a success.
  ]##
  value.success(result.failureType())


proc tryParseNim* (
  tryRead: EnvVarName -> Optional[EnvVarValue]
): Optional[Result[FilePath, () -> ref ParseEnvError]] =
  envNim().tryRead().map(parseNim)



func parseNimFlags* (
  value: EnvVarValue
): Result[string, () -> ref ParseEnvError] =
  ##[
    Does currently nothing other than returning a success.
  ]##
  value.success(result.failureType())


proc tryParseNimFlags* (
  tryRead: EnvVarName -> Optional[EnvVarValue]
): Optional[Result[string, () -> ref ParseEnvError]] =
  envNimFlags().tryRead().map(parseNimFlags)
