{pkgs, inputs, ...}: {
  environment.systemPackages = with pkgs; [
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
    spotify
    gcc
    cacert
    wget
    curl
    tree
    mesa
    socat
    gawk
    nmap
    unzip
    fd
    jq
    bash
    zsh
    slop
    httpie
    cachix
    rclone
    openssl
  ];
}
