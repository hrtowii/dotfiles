{ config, pkgs, lib, ... }:

let
  cfg = config.cxx-minimal;
in
{
  options.cxx-minimal = {
    enable = lib.mkEnableOption "minimal C/C++ build tools (cmake + gcc + gdb)";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cmake
      gnumake
      gcc
      gdb
    ];
  };
}
