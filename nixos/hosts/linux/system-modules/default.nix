{
  pkgs,
  vars,
  hostVars,
  ...
}:
{
  imports = [
    ../../../modules/docker.nix
    ../../../modules/steam.nix
    ../../../modules/python.nix
    ../../../modules/npm.nix
    ../../../modules/tailscale.nix
    ../../../modules/rust.nix
    #    ../../../modules/ollama.nix
    ../../../modules/flatpak.nix
    ../../../modules/hyprland.nix
    ../../../modules/keyring.nix
    ../../../modules/uwsm.nix
    ../../../modules/dotnet.nix
    ../../../modules/nvidia.nix
    ../../../modules/zsh.nix
    ../../../modules/tablet.nix
    ../../../modules/env.nix
    ../../../modules/spotify-player.nix
    ../../../modules/slack.nix
    ../../../modules/vm.nix
    ../../../modules/ld.nix
    ../../../modules/chinese.nix
    ../../../modules/env.nix
    ../../../modules/bluetooth.nix
    ../../../modules/cmake.nix
    ../../../modules/pwn.nix
    ../../../modules/qt.nix
    ../../../modules/sdr.nix
    ../../../modules/ida.nix
    ../../../modules/cache
    ../../../modules/cache/cachix.nix
    ../../../modules/sway.nix
    ../../../modules/kitty.nix
    ../../../modules/stylix.nix
    ../../../modules/moonlight.nix
  ];

  npm.enable = true;

  rust.enable = true;
  cxx-minimal.enable = true;
  pwn.enable = true;
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
