final: prev: {
  writeShellApplication = args:
    prev.writeShellApplication (args // {
      excludeShellChecks = (args.excludeShellChecks or []) ++ [ "SC2209" ];
    });
}
