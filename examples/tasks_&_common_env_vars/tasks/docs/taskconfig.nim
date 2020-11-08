import pkg/taskutils/[filetypes]



type
  TaskConfig* = tuple
    outDir: DirPath



func taskConfig* (outputDir: DirPath): TaskConfig =
  (outputDir, )
