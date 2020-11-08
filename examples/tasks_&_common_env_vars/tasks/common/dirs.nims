import pkg/taskutils/[dirs, filetypes]

import std/[os]



func defaultCacheDir* (): AbsoluteDir =
  getCurrentDir() / nimbleCache()
