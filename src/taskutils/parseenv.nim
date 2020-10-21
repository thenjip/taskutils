import envtypes, optional, result

import std/[strformat, sugar]



type
  ParseEnvError* = object of CatchableError



proc parseEnvError* (msg: string): ref ParseEnvError =
  ParseEnvError.newException(msg)


proc parseEnvError* (name: EnvVarName; reason: string): ref ParseEnvError =
  parseEnvError(fmt"{name}: {reason}")



proc readOrEmpty* (
  name: EnvVarName;
  read: EnvVarName -> EnvVarValue
): Optional[EnvVarValue] =
  ##[
    If the environment variable value is an empty string, an empty `Option` is
    returned.
  ]##
  let value = name.read()

  if value.len() == 0:
    value.typeof().none()
  else:
    value.some()


proc tryParse* [T; E](
  name: EnvVarName;
  tryRead: EnvVarName -> Optional[EnvVarValue];
  parse: EnvVarValue -> Result[T, E]
): Optional[Result[T, E]] =
  name.tryRead().map(parse)
