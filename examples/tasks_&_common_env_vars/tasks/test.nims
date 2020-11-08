import common/"dirs.nims" as taskdirs
import common/[project]
import test/["env.nims", taskconfig]

import pkg/taskutils/[
  cmdline,
  fileiters,
  filetypes,
  nimcmdline,
  optional,
  result
]

import std/[os, sequtils]



func defaultOutDir (): AbsoluteDir =
  defaultCacheDir() / Task.Test.name()


func defaultBackend (): Backend =
  Backend.C



func tryParseEnvConfig (): TaskConfig =
  taskConfig(
    tryParseOutDir.failOr(defaultOutDir),
    tryParseNimBackend.failOr(defaultBackend)
  )



func compileAndRunCmdOptions (config: TaskConfig): seq[string] =
  let outputDir = config.outDir / config.backend.envVarValue()

  @["run".nimLongOption()]
    .concat(
      {
        "outdir": outputDir,
        "nimcache": outputDir
      }.toNimLongOptions()
    )


func compileAndRunCmd (module: FilePath; config: TaskConfig): string =
  let
    nimCmd = config.backend.nimCmd()
    options = config.compileAndRunCmdOptions()

  @[nimCmd].concat(options, @[module.quoteShell()]).cmdLine()



when isMainModule:
  proc main () =
    let config = tryParseEnvConfig()

    for module in testsDirName().absoluteNimModules():
      module.compileAndRunCmd(config).selfExec()



  main()
