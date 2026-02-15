{pkgs, vars, hostVars, ...}: {
  imports = [
    ../docker.nix
    ../steam.nix
    # ../python.nix
    ../npm.nix
    ../tailscale.nix
    ../rust.nix
#    ../ollama.nix
    ../flatpak.nix
    ../hyprland.nix
    ../keyring.nix
    ../uwsm.nix
    ../dotnet.nix
    ../nvidia.nix
    ../zsh.nix
    ../tablet.nix
    ../env.nix
    ../spotify-player.nix
    ../slack.nix
    ../vm.nix
    ../ld.nix
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
