import common/"dirs.nims" as taskdirs
import common/[project]
import docs/["env.nims", taskconfig]

import pkg/taskutils/[
  cmdline,
  fileiters,
  filetypes,
  nimcmdline,
  optional,
  result
]

import std/[os, sequtils]



func defaultOutDir (): DirPath =
  defaultCacheDir() / Task.Docs.name()



func tryParseEnvConfig (): TaskConfig =
  taskConfig(tryParseOutDir.failOr(defaultOutDir))



func genDocCmdOptions (config: TaskConfig): seq[string] =
  const
    repoUrl = "https://github.com/foo/foo"
    mainGitBranch = "main"

  @["project".nimLongOption()]
    .concat(
      {
        "outdir": config.outDir,
        "git.url": repoUrl,
        "git.devel": mainGitBranch,
        "git.commit": mainGitBranch
      }.toNimLongOptions()
    )


func genDocCmd (config: TaskConfig): string =
  const mainModule = srcDirName() / nimbleProjectName().addFileExt(nimExt())

  let options = config.genDocCmdOptions()

  @["doc"].concat(options, @[mainModule.quoteShell()]).cmdLine()



when isMainModule:
  proc main () =
    let config = tryParseEnvConfig()

    config.genDocCmd().selfExec()



  main()
