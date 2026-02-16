{
  pkgs,
  lib,
  ...
}: {
  environment.shellInit = ''
    export PATH="$PATH:${pkgs.rustc}/bin"
    export PATH="$PATH:${pkgs.cargo}/bin"
    if [ -d "$HOME/.cargo/bin" ]; then
      export PATH="$PATH:$HOME/.cargo/bin"
    fi
    if [ -d "$HOME/.npm-global/bin" ]; then
      export PATH="$PATH:$HOME/.npm-global/bin"
    fi
  '';
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERM = "ghostty";
    CC = "${pkgs.gcc}/bin/gcc";
    LUA_PATH = "${pkgs.luajit}/share/lua/5.1/?.lua;${pkgs.luajit}/share/lua/5.1/?/init.lua;;";
    LUA_CPATH = "${pkgs.luajit}/lib/lua/5.1/?.so;;";
    NIXOS_OZONE_WL = "1";

    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    PKG_CONFIG_PATH = lib.makeSearchPath "lib/pkgconfig" [
      pkgs.openssl.dev
      pkgs.rustc
      pkgs.cargo
      # pkgs.mesa
      # pkgs.openssl.dev
      # pkgs.libxml2.dev
      pkgs.zlib.dev
      # pkgs.portaudio
      # pkgs.alsa-lib
      pkgs.stdenv.cc.cc
      # pkgs.xorg.libX11.dev
      # pkgs.xorg.libXtst
      # pkgs.xorg.libXi.dev
    ];
    LD_LIBRARY_PATH = lib.makeLibraryPath [
      # pkgs.libglvnd
      # pkgs.mesa
      # pkgs.gcc-unwrapped.lib
      # pkgs.linuxPackages.nvidia_x11
      # pkgs.cudatoolkit
      # pkgs.mangohud
      # pkgs.portaudio
      pkgs.rustc
      pkgs.cargo
      pkgs.zlib.dev
      pkgs.stdenv.cc.cc.lib
      # pkgs.xorg.libX11
      # pkgs.xorg.libXtst
      # pkgs.xorg.libXi
      # pkgs.glib
    ];
  };

  # environment.pathsToLink = [
  #   "/share/fish"
  #   "/bin"
  # ];

  # programs.direnv = {
  #   enable = true;
  #   nix-direnv.enable = true;
  # };
}
