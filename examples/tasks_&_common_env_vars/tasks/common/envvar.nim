import pkg/taskutils/[envtypes, filetypes, optional, parseenv, result]

import std/[strutils, sugar]



func findIndex* [I; T](self: array[I, T]; predicate: T -> bool): Optional[I] =
  result = I.none()

  for i, item in self:
    if item.predicate():
      return i.some()



func nimBackend* (): EnvVarName =
  "NIM_BACKEND"


func outDir* (): EnvVarName =
  "OUTDIR"



func parseDirPath* (
  name: EnvVarName;
  envValue: EnvVarValue
): ParseEnvResult[DirPath] =
  func invalidPath (): ref ParseEnvError =
    name.parseEnvError("Path is blank or empty.")

  envValue
    .some()
    .filter(s => not s.isEmptyOrWhitespace())
    .ifSome(parseEnvSuccess, () => invalidPath.parseEnvFailure(DirPath))
