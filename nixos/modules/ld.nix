{
  config,
  pkgs,
  options,
  ...
}:

{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      libglvnd
      mesa
      cryptopp
      wayland
      speex
      speexdsp
      libusb1
      qt5.qtbase
      libx11
      libxext
      libxrender
      xorg.libXrandr
      libxcb
      libxi
      xorg.libXcursor
      xorg.libXinerama

      xorg.xcbutil
      libxcb-image
      libxcb-keysyms
      libxcb-render-util
      libxcb-wm
      xorg.xcbutilcursor # provides libxcb-cursor.so.0

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
