{ config, pkgs, inputs, ... }:

{
  imports = [
    ./modules/homebrew.nix
    ./modules/aerospace.nix
    ./modules/npm.nix 
    ./modules/rust.nix
    ./modules/python.nix
    ./modules/skhd.nix
    # ./modules/tailscale.nix
  ];
  npm.enable = true;
  rust.enable = true;

  networking.hostName = "homura";
  networking.computerName = "homura";
  networking.localHostName = "homura";

  system.primaryUser = "ibarahime";

  users.users.ibarahime = {
    name = "ibarahime";
    home = "/Users/ibarahime";
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

  # environment.systemPackages = with pkgs; [
  # ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = 5;
}
