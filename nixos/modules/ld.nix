{ config, pkgs, options, ... }:

{
  programs.nix-ld = {
    enable = true;
    libraries = options.programs.nix-ld.libraries.default ++ (with pkgs; [
      glib # Provides libglib-2.0.so.0, libgthread-2.0.so.0
    ]);
  };

}

