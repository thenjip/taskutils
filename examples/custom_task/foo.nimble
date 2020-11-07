func srcDirName* (): string =
  "src"



version = "0.1.0"
author = "foo"
description = "foo"
license = "MIT"

srcDir = srcDirName()

requires "nim >= 1.4.0"
requires "https://github.com/thenjip/taskutils >= 0.2.1"



import std/[macros, os, sequtils, sugar]



func taskScriptsDirName (): string =
  "tasks"


func nims (file: string): string =
  file.addFileExt("nims")



# Task API

type
  Task* {.pure.} = enum
    Docs



func name (self: Task): string =
  const names: array[Task, string] = ["docs"]

  names[self]


func identifier (self: Task): NimNode =
  self.name().ident()


func description (self: Task): string =
  const descriptions: array[Task, string] = [
    "Generate the API documentation."
  ]

  descriptions[self]



macro define (self: static Task; body: Task -> void): untyped =
  let
    selfIdent = self.identifier()
    selfLit = self.newLit()

  quote do:
    task `selfIdent`, `selfLit`.description():
      `body`(`selfLit`)


proc execScript (self: Task) =
  taskScriptsDirName().`/`(self.name().nims()).selfExec()


macro defineTasks (): untyped =
  toSeq(Task.items())
    .map(
      proc (task: auto): auto =
        let
          taskLiteral = task.newLit()

        quote do:
          `taskLiteral`.define(execScript)
    ).newStmtList()



defineTasks()
