import filetypes

import std/[os]



func nimbleCache* (): string =
  ".nimblecache"



func crossCompilerCache* (baseOutputDir: AbsoluteDir): AbsoluteDir =
  ##[
    Returns a direcotry path to a cache suitable for cross compilation.

    Since 0.2.0.
  ]##
  baseOutputDir / hostOS / hostCPU


func compilerCache* (baseOutputDir: AbsoluteDir): AbsoluteDir {.deprecated.} =
  ##[
    Deprecated since 0.2.0.
    Use `crossCompilerCache` instead.
  ]##
  baseOutputDir.crossCompilerCache()



func outputIn* (taskName: string; baseOutputDir: AbsoluteDir): AbsoluteDir =
  ##[
    Since 0.2.0.
  ]##
  baseOutputDir / taskName


func outputDir* (taskName: string; baseOutputDir: AbsoluteDir): AbsoluteDir {.
  deprecated
.} =
  ##[
    Deprecated since 0.2.0.
    Use `outputIn` instead.
  ]##
  taskName.outputIn(baseOutputDir)
