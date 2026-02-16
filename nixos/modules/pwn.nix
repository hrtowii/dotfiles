{ config, pkgs, lib, ... }:

let
  cfg = config.pwn;

  pwndbgFlake = builtins.getFlake "github:pwndbg/pwndbg";

in
{
  options.pwn = {
    enable = lib.mkEnableOption "we love pwning babyyyy";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gdb
      (pwndbgFlake.packages.${pkgs.system}.pwndbg or pwndbgFlake.packages.${pkgs.system}.default)
      
      (python3.withPackages (ps: with ps; [
        pwntools
      ]))

      qemu
      binutils
      patchelf
    ];

    environment.shellInit = ''
      export TERM=linux
      # Optional: if you want pwndbg to auto-load without .gdbinit tricks
      # export PYTHONPATH="${pwndbgFlake.packages.${pkgs.system}.pwndbg}/lib/python3.*/site-packages:$PYTHONPATH"
    '';

    environment.variables = {
      PYTHONPATH = lib.mkBefore "${pkgs.python3.sitePackages}";
    };
  };
}
