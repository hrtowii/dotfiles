{ pkgs, hostVars, ... }:
{
  imports = [
    ../../../modules/docker.nix
    ../../../modules/steam.nix
    ../../../modules/python.nix
    ../../../modules/npm.nix
    ../../../modules/tailscale.nix
    ../../../modules/rust.nix # not needed on thinkpad
    # ../../../modules/ollama.nix
    ../../../modules/flatpak.nix
    ../../../modules/hyprland.nix
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
    # ../../../modules/ida.nix
    ../../../modules/pwn.nix
    ../../../modules/qt.nix
    ../../../modules/sway.nix
  ];

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
