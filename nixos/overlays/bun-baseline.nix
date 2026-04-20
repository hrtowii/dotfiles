final: prev: {
  bun = if prev.stdenv.hostPlatform.system == "x86_64-linux"
    then final.callPackage ../pkgs/bun-baseline { }
    else prev.bun;
}
