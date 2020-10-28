# taskutils

[![Build Status](https://github.com/thenjip/taskutils/workflows/Unit%20tests/badge.svg?branch=main)](https://github.com/thenjip/taskutils/actions?query=workflow%3A"Unit+tests"+branch%3A"main")
[![Licence](https://img.shields.io/github/license/thenjip/taskutils.svg)](https://raw.githubusercontent.com/thenjip/taskutils/main/LICENSE)

Various utilities for tasks in [NimScript](https://nim-lang.org/docs/nims.html).

The library itself is written in Nim, so it can be used in regular Nim code.

## Installation

```sh
nimble install 'https://github.com/thenjip/taskutils'
```

## Dependencies

- [`nim`](https://nim-lang.org/) >= `1.4.0`

## Documentation

- [API](https://thenjip.github.io/taskutils/)

## Overview

### File iterators

```nim
# NimScript

requires "https://github.com/thenjip/taskutils >= 0.1.0"

import pkg/taskutils/[fileiters]
import std/[os]

for file in getCurrentDir().relativeFiles("rst"):
  ["rst2html", file.quoteShell()].join($' ').selfExec()

for test in "tests".absoluteNimModules():
  ["c", "-r", test.quoteShell()].join($' ').selfExec()
```

### Parsing environment variable values

```nim
# NimScript

requires "https://github.com/thenjip/taskutils >= 0.1.0"

import pkg/taskutils/[envtypes, optional, parseenv, result]
import std/[strformat, strutils, sugar]


type
  NimOptimize {.pure.} = enum
    None
    Speed
    Size

  Unit = tuple[]


func envNimOptimize (): string =
  "NIM_OPTIMIZE"


func parseNimOptimize (
  value: EnvVarValue
): Result[NimOptimize, () -> ref ParseEnvError] =
  proc invalidValue (): ref ParseEnvError {.closure.} =
    envNimOptimize().parseEnvError(fmt"Invalid optimization type: {value}")

  case value:
    of "speed":
      NimOptimize.Speed.success(result.failureType())
    of "size":
      NimOptimize.Size.success(result.failureType())
    of "none":
      NimOptimize.None.success(result.failureType())
    else:
      invalidValue.failure(result.successType())


proc getEnvOrEmpty (name: EnvVarName): EnvVarValue =
  name.getEnv()


proc tryGetEnv (name: EnvVarName): Optional[EnvVarValue] =
  name.findValue(existsEnv, getEnvOrEmpty)


proc tryParseNimOptimize (): Optional[
  Result[NimOptimize, () -> ref ParseEnvError]
] =
  envNimOptimize().tryParse(tryGetEnv, parseNimOptimize)


discard
  tryParseNimOptimize()
    .ifSome(
      parseResult =>
        parseResult.ifSuccess(
          proc (optimization: NimOptimize): Unit =
            echo(fmt"optimization: {optimization}")
          ,
          proc (failure: () -> ref ParseEnvError): Unit =
            echo(failure().msg)
        )
      ,
      proc (): Unit =
        echo(fmt"{envNimOptimize()} not set.")
    )
```
