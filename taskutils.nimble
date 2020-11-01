func libSrcDir (): string =
  "src"



version = "0.2.0"
author = "thenjip"
description = "Various utilities for tasks in NimScript."
license = "MIT"

srcDir = libSrcDir()

requires "nim >= 1.4.0"



import std/[macros, os, sequtils, strformat, strutils, sugar]



func nimbleProjectName (): string =
  "taskutils"


func nimbleCache (): string =
  ".nimblecache"


func nimbleCacheDir (): string =
  getCurrentDir() / nimbleCache()



type
  Task {.pure.} = enum
    Test,
    Docs,
    Clean



func name (self: Task): string =
  const names: array[Task, string] = [
    "test",
    "docs",
    "clean"
  ]

  names[self]


macro identifier (self: static Task): untyped =
  self.name().newLit()


func description (self: Task): string =
  const descriptions: array[Task, string] = [
    "Run the tests.",
    "Generate the API documentation.",
    "Clean the build directory."
  ]

  descriptions[self]



macro define (self: static Task; body: Task -> void): untyped =
  let
    selfIdent = self.name().ident()
    selfLit = self.newLit()

  quote do:
    task `selfIdent`, `selfLit`.description():
      `body`(`selfLit`)



define(
  Task.Test,
  proc (_: Task) =
    func testsDir (): string =
      "tests"

    func runTestCmd (test: string): string =
      ["e", test].join($' ')

    withDir testsDir():
      for kind, path in getCurrentDir().walkDir():
        if kind == pcFile and path.endsWith(fmt"{ExtSep}nims"):
          let test = path

          echo(fmt"Suite: {test.splitFile().name}")
          test.runTestCmd().selfExec()
)


define(
  Task.Docs,
  proc (task: Task) =
    func outputDir (): string =
      nimbleCacheDir() / task.name()

    func genDocCmd (): string =
      const
        repoUrl = "https://github.com/thenjip/taskutils"
        mainGitBranch = "main"
        mainModule = libSrcDir() / nimbleProjectName().addFileExt("nim")

      @["doc"]
        .concat(
          [
            "project",
            fmt"outdir:{outputDir().quoteShell()}",
            fmt"git.url:{repoUrl.quoteShell()}",
            fmt"git.devel:{mainGitBranch}",
            fmt"git.commit:{mainGitBranch}"
          ].map(opt => fmt"--{opt}"),
          @[mainModule.quoteShell()]
        ).join($' ')

    genDocCmd().selfExec()
    withDir outputDir():
      "theindex".addFileExt("html").cpFile("index".addFileExt("html"))
)


define(
  Task.Clean,
  proc (_: Task) =
    proc tryRmDir (dir: string) =
      dir.rmDir()

    nimbleCacheDir().tryRmDir()
)
