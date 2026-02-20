{ config, pkgs, lib, hostVars, ... }:

{
  imports = [
  ./config.nix
  ./modules/git.nix
  ./modules/spicetify.nix
  ./modules/zsh.nix
  ./modules/sketchybar.nix
  ./modules/ripgrep.nix
  ./modules/zellij.nix
  ./modules/fonts.nix
];
  home.username = hostVars.username;
  home.homeDirectory = "${hostVars.homePrefix}/${hostVars.username}";
  home.stateVersion = hostVars.stateVersion;
  programs.home-manager.enable = true;
  home.packages = [ ];
}
