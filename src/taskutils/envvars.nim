import envtypes, filetypes, optional, parseenv, result

import std/[os, sugar]



func envNim* (): string =
  "NIM"


func envNimFlags* (): string =
  "NIMFLAGS"



func parseNim* (value: EnvVarValue): Result[FilePath, () -> ref ParseEnvError] =
  proc invalidFileName (): ref ParseEnvError {.closure.} =
    envNim().parseEnvError("Invalid file name.")

  if value.isValidFilename():
    value.success(result.failureType())
  else:
    invalidFileName.failure(result.successType())


proc tryParseNim* (
  tryRead: EnvVarName -> Optional[EnvVarValue]
): Optional[Result[FilePath, () -> ref ParseEnvError]] =
  envNim().tryRead().map(parseNim)



func parseNimFlags* (
  value: EnvVarValue
): Result[string, () -> ref ParseEnvError] =
  value.success(result.failureType())


proc tryParseNimFlags* (
  tryRead: EnvVarName -> Optional[EnvVarValue]
): Optional[Result[string, () -> ref ParseEnvError]] =
  envNimFlags().tryRead().map(parseNimFlags)
