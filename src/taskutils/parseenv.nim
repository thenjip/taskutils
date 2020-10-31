import envtypes, optional, result

import std/[strformat, sugar]



type
  ParseEnvError* = object of CatchableError

  ParseEnvResult* [T] = Result[T, () -> ref ParseEnvError]



func parseEnvError* (msg: string): ref ParseEnvError =
  ParseEnvError.newException(msg)


func parseEnvError* (name: EnvVarName; reason: string): ref ParseEnvError =
  fmt"{name}: {reason}".parseEnvError()



func parseEnvSuccess* [T](value: T): ParseEnvResult[T] =
  value.success(result.failureType())


func parseEnvFailure* (
  fail: () -> ref ParseEnvError;
  T: typedesc
): ParseEnvResult[T] =
  fail.failure(T)



proc findValue* (
  name: EnvVarName;
  exists: EnvVarName -> bool;
  read: EnvVarName -> EnvVarValue
): Optional[EnvVarValue] =
  if name.exists():
    name.read().some()
  else:
    result.boxedType().none()


proc tryParse* [T; E](
  name: EnvVarName;
  find: EnvVarName -> Optional[EnvVarValue];
  parse: EnvVarValue -> Result[T, E]
): Optional[Result[T, E]] =
  find(name).map(parse)
