{ config, pkgs, options, ... }:

{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
  libglvnd
  mesa

  wayland

  xorg.libX11
  xorg.libXext
  xorg.libXrender
  xorg.libXrandr
  xorg.libxcb
  xorg.libXi
  xorg.libXcursor
  xorg.libXinerama

  xorg.xcbutil
  xorg.xcbutilimage
  xorg.xcbutilkeysyms
  xorg.xcbutilrenderutil
  xorg.xcbutilwm
  xorg.xcbutilcursor   # provides libxcb-cursor.so.0

  libxkbcommon

  zlib
  glib
  fontconfig
  freetype
  dbus

  stdenv.cc.cc
];

  };
}

