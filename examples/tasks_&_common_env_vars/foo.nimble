func srcDirName* (): string =
  "src"



version = "0.1.0"
author = "foo"
description = "foo"
license = "MIT"

srcDir = srcDirName()

requires "nim >= 1.4.0"
requires "https://github.com/thenjip/taskutils >= 0.2.1"



import std/[macros, os, sequtils, strutils, sugar]



func testsDirName* (): string =
  "tests"


func taskScriptsDirName (): string =
  "tasks"


func nims (file: string): string =
  file.addFileExt("nims")



# Task API

type
  Task* {.pure.} = enum
    Docs
    Test



func name* (self: Task): string =
  const names: array[Task, string] = [
    "docs",
    "test"
  ]

  names[self]


func identifier (self: Task): NimNode =
  self.name().ident()


func docsTaskDescription (): string =
  [
    "Generate the API documentation.",
    "OUTDIR can be set in the environment to configure the output directory."
  ].join($' ')


func testTaskDescription (): string =
  [
    "Compile and run the tests.",
    "The backend can be configured with \"NIM_BACKEND=(c|cxx|objc|js)\".",
    "OUTDIR can be set in the environment to configure the output directory."
  ].join($' ')


func description (self: Task): string =
  const descriptions: array[Task, string] = [
    docsTaskDescription(),
    testTaskDescription()
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
