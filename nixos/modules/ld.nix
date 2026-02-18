{ config, pkgs, options, ... }:

{
  programs.nix-ld = {
    enable = true;
  };

programs.nix-ld.libraries = with pkgs; [
  libglvnd
  mesa

  xorg.libX11
  xorg.libXext
  xorg.libXrender
  xorg.libXrandr
  xorg.libxcb
  xorg.libXi
  xorg.libXcursor
  xorg.libXinerama

  libxkbcommon

  zlib
  glib
  fontconfig
  freetype
  dbus

  stdenv.cc.cc
];
}

