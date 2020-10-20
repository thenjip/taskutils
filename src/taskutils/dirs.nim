import filetypes

import std/[os]



func nimbleCache* (): string =
  ".nimblecache"



func compilerCache* (baseOutputDir: AbsoluteDir): AbsoluteDir =
  ##[
    Returns a path to the directory for the compiler's cache.
  ]##
  baseOutputDir / hostOS / hostCPU



func outputDir* (taskName: string; baseOutputDir: AbsoluteDir): AbsoluteDir =
  baseOutputDir / taskName
