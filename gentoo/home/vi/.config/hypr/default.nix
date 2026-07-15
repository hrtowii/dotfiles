{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ./packages.nix          # Caelestia scripts and quickshell wrapper derivations
    ./config.nix           # Configuration files and environment setup
  ];

  # Main packages
  home.packages = with pkgs; [
    material-symbols
    nerd-fonts.jetbrains-mono
    ibm-plex
  ];
}