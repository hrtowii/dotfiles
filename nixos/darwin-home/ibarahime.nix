{ config, pkgs, lib, ... }:

{
  imports = [
  ./config.nix
  ./modules/git.nix
  ./modules/spicetify.nix
  ./modules/zsh.nix
  ./modules/sketchybar.nix
];
  home.username = "ibarahime";
  home.homeDirectory = "/Users/ibarahime";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
  
  home.packages = [ ];
}
