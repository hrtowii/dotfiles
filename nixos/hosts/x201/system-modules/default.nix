{ pkgs, hostVars, ... }:
{
  imports = [
    # ../../../modules/aseprite.nix
    ../../../modules/docker.nix
    # ../../../modules/steam.nix
    ../../../modules/python.nix
    ../../../modules/npm.nix
    ../../../modules/tailscale.nix
    ../../../modules/rust.nix # not needed on thinkpad
    # ../../../modules/ollama.nix
    ../../../modules/flatpak.nix
    # ../../../modules/hyprland.nix
    ../../../modules/keyring.nix
    ../../../modules/uwsm.nix
    ../../../modules/dotnet.nix
    # ../../../modules/nvidia.nix    # no nvidia on thinkpad
    ../../../modules/zsh.nix
    # ../../../modules/tablet.nix    # no tablet on thinkpad
    ../../../modules/ld.nix
    ../../../modules/chinese.nix
    ../../../modules/env.nix
    ../../../modules/bluetooth.nix
    ../../../modules/ida.nix
    ../../../modules/pwn.nix
    ../../../modules/qt.nix
    ../../../modules/sway.nix
    ../../../modules/spotify-player.nix
    ../../../modules/kitty.nix
    ../../../modules/stylix.nix
    # ../../../modules/cache
  ];
  stylixConfig = {
    enable   = true;
    wallpaper = ../../../home-manager/config/wallpapers/getwellsoon.jpg;
    duotone = false;
    fonts = {
    	i3status = { name = "Xanh Mono"; size = 12; };
    };
    # fonts = {
    #   monospace = { name = "Fira Code"; package = pkgs.fira-code; };
    #   serif = { name = "Noto Serif"; package = pkgs.noto-fonts; };
    #   sizes.terminal = 13;
    #   sway = { name = "Cohere Mono"; size = 8; };
    #   i3status = { name = "Cohere Mono"; size = 10; };
    # };
  };
  npm.enable = true;
  rust.enable = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "${hostVars.homePrefix}/${hostVars.username}/dotfiles/nixos";
  };
}
