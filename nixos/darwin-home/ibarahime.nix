{ config, pkgs, lib, ... }:

{
  imports = [
  ./config.nix
  ./modules/git.nix
  ./modules/spicetify.nix
  ./modules/zsh.nix
  ./modules/sketchybar.nix
  ./modules/ripgrep.nix
  ./modules/zellij.nix
];
  home.username = "ibarahime";
  home.homeDirectory = "/Users/ibarahime";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
  
  home.packages = [ ];
}
