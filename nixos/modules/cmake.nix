{ config, pkgs, lib, ... }:

let
  cfg = config.programs.dev.cxx-minimal;
in
{
  options.programs.dev.cxx-minimal = {
    enable = lib.mkEnableOption "minimal C/C++ build tools (cmake + gcc + gdb)";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cmake
      gcc
      gdb
    ];

    # Optional: default to Ninja if you ever use it (most people do these days)
    environment.shellInit = ''
      export CMAKE_GENERATOR="Ninja"
    '';
  };
}
