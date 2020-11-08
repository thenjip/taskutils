import common/["env.nims", project]
import docs/[envvar]

import pkg/taskutils/[
  cmdline,
  fileiters,
  filetypes,
  nimcmdline,
  optional,
  parseenv,
  result
]

import std/[os, sequtils, sugar]



func tryParseOutDir (): Optional[ParseEnvResult[DirPath]] =
  EnvVar.OutDir.name().tryParse(findInEnv, parseOutDir)


func defaultOutDir (): DirPath =
  getCurrentDir() / "htmldocs"



func genDocCmdOptions (): seq[string] =
  const
    repoUrl = "https://github.com/foo/foo"
    mainGitBranch = "main"

  let outdir = tryParseOutDir().ifSome(unboxSuccessOrRaise, defaultOutDir)

  concat(
    @["project".nimLongOption()],
    {
      "outdir": outdir,
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
