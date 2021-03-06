# taskutils

[![Build Status](https://github.com/thenjip/taskutils/workflows/Tests/badge.svg?branch=main)](https://github.com/thenjip/taskutils/actions?query=workflow%3A"Tests"+branch%3A"main")
[![Licence](https://img.shields.io/github/license/thenjip/taskutils.svg)](https://raw.githubusercontent.com/thenjip/taskutils/main/LICENSE)

Various utilities for tasks in [NimScript](https://nim-lang.org/docs/nims.html).

The library itself is written in Nim, so it can be used in regular Nim code.

## Rationale

The main motivation is to see whether it is possible to import external
packages in Nimble scripts.

It is technically possible, but the external packages must be installed manually
before running the Nimble script. Indeed, the script has to be verified by the
compiler first, the `requires` statements only occur after, at runtime.

This becomes quite inconvenient when installing the package associated with the
script.

The experimented solution with this project is to:

- Move the code that depends on external packages out in regular NimScript
  files.
- Write Nimble tasks that execute the corresponding scripts.

This project plays the role of an imported external package.

## Installation

```sh
nimble install 'https://github.com/thenjip/taskutils'
```

## Dependencies

- [`nim`](https://nim-lang.org/) >= `1.4.0`

## Documentation

- [API](https://thenjip.github.io/taskutils/)

## Examples

Examples of integration with Nimble project files can be found [here](examples).

## Overview

### File iterators

```nim
# NimScript

import pkg/taskutils/[cmdline, fileiters]
import std/[os]


for file in getCurrentDir().relativeFiles("rst"):
  ["rst2html", file.quoteShell()].cmdLine().selfExec()

for test in "tests".absoluteNimModules():
  ["c", "-r", test.quoteShell()].cmdLine().selfExec()
```

### A few extensions of [`std/options`](https://nim-lang.org/docs/options.html)

```nim
# NimScript

import pkg/taskutils/[optional]
import std/[sugar]


let i = 0
doAssert(i.some().boxedType() is i.typeof())
doAssert(i.some().ifSome(i => i, () => -1) == i)
doAssert(i.some().ifNone(() => -1, i => 1) == 1)
```

### The result type

It is mainly used to make dealing with errors part of the API.

```nim
# NimScript

import pkg/taskutils/[cmdline, result, unit]
import std/[strformat, strutils, sugar]


type
  ShellCmdSuccess = tuple
    output: string
  ShellCmdFailure = tuple
    cmd: string
    exitCode: int
  ShellCmdResult = Result[ShellCmdSuccess, ShellCmdFailure]


func shellCmdSuccess (output: string): ShellCmdResult =
  (output, ).success(ShellCmdFailure)

func shellCmdFailure (cmd: string; exitCode: int): ShellCmdResult =
  (cmd, exitCode).failure(ShellCmdSuccess)

proc execInShell (cmd, input: string): ShellCmdResult =
  let (output, exitCode) = cmd.gorgeEx(input)

  if exitCode == QuitSuccess:
    output.shellCmdSuccess()
  else:
    cmd.shellCmdFailure(exitCode)

proc execInShell (cmd: string): ShellCmdResult =
  cmd.execInShell("")

proc pipe (self: ShellCmdResult; cmd: string): ShellCmdResult =
  self.flatMap((previous: ShellCmdSuccess) => cmd.execInShell(previous.output))


["echo", "\"hello\""]
  .cmdLine()
  .execInShell()
  .pipe(["grep", "-so", $'l'].cmdLine())
  .ifSuccess(
    proc (success: auto): Unit =
      echo(success.output)
    ,
    proc (failure: auto): Unit =
      [fmt"Command failed: {failure.cmd}", fmt"Exit code: {failure.exitCode}"]
        .join($'\n')
        .echo()
  ).ignore()
```

### Parsing environment variable values

```nim
# NimScript

import pkg/taskutils/[envtypes, optional, parseenv, result, unit]
import std/[strformat, strutils, sugar]


type
  NimOptimize {.pure.} = enum
    None
    Speed
    Size


func envNimOptimize (): EnvVarName =
  "NIM_OPTIMIZE"

func parseNimOptimize (value: EnvVarValue): ParseEnvResult[NimOptimize] =
  proc invalidValue (): ref ParseEnvError =
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

proc tryParseNimOptimize (): Optional[ParseEnvResult[NimOptimize]] =
  envNimOptimize().tryParse(tryGetEnv, parseNimOptimize)


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
  ).ignore()
```
