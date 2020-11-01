import filetypes

import std/[os]



func nimbleCache* (): string =
  ".nimblecache"



func compilerCache* (baseOutputDir: AbsoluteDir): AbsoluteDir =
  ##[
    Returns a path to the directory for the compiler's cache.
  ]##
  baseOutputDir / hostOS / hostCPU



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
