{
  pkgs,
  lib,
  ...
}: {
  environment.shellInit = ''
    # Existing desktop sessions can retain the old global runtime override
    # after a rebuild. Do not pass it on to new shells and Nix applications.
    unset LD_LIBRARY_PATH

    export PATH="$PATH:${pkgs.rustc}/bin"
    export PATH="$PATH:${pkgs.cargo}/bin"
    if [ -d "$HOME/.cargo/bin" ]; then
      export PATH="$PATH:$HOME/.cargo/bin"
    fi
    if [ -d "$HOME/.npm-global/bin" ]; then
      export PATH="$PATH:$HOME/.npm-global/bin"
    fi

    # Python wheels (the original fixpandas workaround) may need system
    # libraries even though Python itself does not run through nix-ld.
    # Opt in per command: with-nix-libs python -c 'import pandas'
    with-nix-libs() {
      LD_LIBRARY_PATH="''${NIX_LD_LIBRARY_PATH:-/run/current-system/sw/share/nix-ld/lib}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" "$@"
    }
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
    # Keep library paths scoped to individual applications. A global
    # LD_LIBRARY_PATH overrides Nix packages' own C++ runtime dependencies.
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
