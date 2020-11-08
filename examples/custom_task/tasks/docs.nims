import common/[project]

import pkg/taskutils/[cmdline, fileiters, nimcmdline]

import std/[os, sequtils]



func genDocCmdOptions (): seq[string] =
  const
    repoUrl = "https://github.com/foo/foo"
    mainGitBranch = "main"

  concat(
    @["project".nimLongOption()],
    {
      "git.url": repoUrl,
      "git.devel": mainGitBranch,
      "git.commit": mainGitBranch
    }.toNimLongOptions()
  )


func genDocCmd (): string =
  const mainModule = srcDirName() / nimbleProjectName().addFileExt(nimExt())

  @["doc"]
    .concat(
      genDocCmdOptions(),
      @["project".nimLongOption()],
      @[mainModule.quoteShell()]
    ).cmdLine()



when isMainModule:
  proc main () =
    genDocCmd().selfExec()



  main()
