import foo/[a]



proc testA () =
  a()



when isMainModule:
  proc main () =
    testA()



  main()

