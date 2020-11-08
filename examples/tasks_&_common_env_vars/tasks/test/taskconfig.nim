import backend

import pkg/taskutils/[filetypes]



type
  TaskConfig* = tuple
    outDir: DirPath
    backend: Backend



func taskConfig* (outDir: DirPath; backend: Backend): TaskConfig =
  (outDir, backend)
