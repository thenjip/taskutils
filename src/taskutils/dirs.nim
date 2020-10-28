import filetypes

import std/[os]



func nimbleCache* (): string =
  ".nimblecache"



func compilerCacheDir* [D: DirPath](baseOutputDir: D): D =
  ##[
    Returns a path to the directory for the compiler's cache suitable for cross
    compilation.
  ]##
  baseOutputDir / hostOS / hostCPU



func outputDir* [D: DirPath](taskName: string; baseOutputDir: D): D =
  baseOutputDir / taskName
