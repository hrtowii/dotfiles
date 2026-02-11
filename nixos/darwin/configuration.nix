{ config, pkgs, inputs, hostVars, ... }:

{
  imports = [
    ./modules/homebrew.nix
    ./modules/aerospace.nix
    ./modules/npm.nix 
    ./modules/rust.nix
    ./modules/python.nix
    ./modules/skhd.nix
    ./modules/cmake.nix
    ./modules/moonlight.nix
    # ./modules/tailscale.nix
  ];
  npm.enable = true;
  rust.enable = true;

  networking.hostName = hostVars.hostname;
  networking.computerName = hostVars.hostname;
  networking.localHostName = hostVars.hostname;

  system.primaryUser = hostVars.username;

  users.users.${hostVars.username} = {
    name = hostVars.username;
    home = "${hostVars.homePrefix}/${hostVars.username}";
    shell = pkgs.zsh;
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.nixos.org"
      "https://cache.lix.systems"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  nix.optimise.automatic = true;

  environment.systemPackages = with pkgs; [
    git-filter-repo
    git-lfs
    cachix
    # claude-code
    # opencode
    # tree 
    bottom
    tokei 
    wget
    zoxide 
    rclone 
    fzf
    btop
    cmatrix
    gh
    ldid-procursus
    eza
    fastfetch
    hugo
    hyperfine
    mpd 
    mpdscribble 
    nasm 
    ncdu 
    nh
  ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = 5;
}
