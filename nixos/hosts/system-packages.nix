# TODO: cleanout and repopulate individual packages better
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # obs-studio
    spotify
    # flameshot
    # mpv
    # linuxHeaders
    # appimage-run
    # freetype.dev
    # go
    # go-tools
    # gopls
    gcc
    # gnumake
    # cmake
    # ninja
    # binutils
    # gdb
    # pkg-config
    # autoconf
    # automake
    # libtool
    # dbus.dev
    # pkg-config
    # ghc
    cacert
    wget
    curl
    tree
    mesa
    # libglvnd
    socat
    gawk
    nmap
    # psmisc
    unzip
    fd
    jq
    bash
    zsh
    slop
    httpie
    # wrk
    # hashcat
    # nix-prefetch-git
    # openssl
    # openssl.dev
    # libxml2
    # zlib
    # zlib.dev
    # postgresql
    # sqlite
    # redis
    # sqls
    cachix
    # texlive.combined.scheme-full
    # imagemagick
    rclone
    openssl
  ];
}
