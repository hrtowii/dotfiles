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
      libxrandr
      libxcb
      libxi
      libxcursor
      libxinerama
      libxcb-util
      libxcb-keysyms
      libxcb-render-util
      libxcb-wm
      libxcb-cursor # provides libxcb-cursor.so.0

      libxkbcommon

      zlib
      glib
      fontconfig
      freetype
      dbus

      stdenv.cc.cc
      alsa-lib
    ];

  };
}
