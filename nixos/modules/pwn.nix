{ config, pkgs, lib, pwndbg, ... }:

let
  cfg = config.pwn;
in
{
  options.pwn.enable = lib.mkEnableOption "pwndbg environment";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gdb
      pwndbg.packages.${pkgs.system}.default

      (python3.withPackages (ps: with ps; [
        pwntools
      ]))

      qemu
      binutils
      patchelf
    ];
  };
}
