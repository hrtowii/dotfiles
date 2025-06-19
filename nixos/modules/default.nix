{pkgs, ...}: {
  imports = [
    ./docker.nix
    ./steam.nix
    ./python.nix
    ./npm.nix
    ./tailscale.nix
    ./rust.nix
    ./ollama.nix
    ./flatpak.nix
    ./hyprland.nix
    ./keyring.nix
    ./uwsm.nix
    ./dotnet.nix
    ./nvidia.nix
    ./zsh.nix
    ./tablet.nix
    ./env.nix
#     ./audio.nix
#     ./bluetooth.nix
#     ./boot.nix
#     ./env.nix
#     ./fonts.nix
#     ./net.nix
#     ./nixos.nix
#     ./nvidia.nix
#     ./timezone.nix
#     ./user.nix
#     ./udiskie.nix
#     ./ld.nix
#     ./x11.nix
#     ./i3-xfce.nix
#     ./cups.nix
  ];

  npm.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
