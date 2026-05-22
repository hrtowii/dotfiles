{ pkgs, hostVars, ... }:
{
  imports = [
    ../docker.nix
    # ../steam.nix
    ../python.nix
    ../npm.nix
    ../tailscale.nix
    ../rust.nix # not needed on thinkpad
    # ../ollama.nix
    ../flatpak.nix
    # ../hyprland.nix
    ../keyring.nix
    ../uwsm.nix
    ../dotnet.nix
    # ../nvidia.nix    # no nvidia on thinkpad
    ../zsh.nix
    # ../tablet.nix    # no tablet on thinkpad
    ../ld.nix
    ../chinese.nix
    ../env.nix
    ../bluetooth.nix
    # ../ida.nix
    ../pwn.nix
    ../qt.nix
    ../sway.nix
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
