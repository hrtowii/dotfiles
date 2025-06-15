{pkgs, ...}: {
  imports = [
#     ./audio.nix
#     ./bluetooth.nix
#     ./boot.nix
    ./docker.nix
#     ./env.nix
#     ./fonts.nix
#     ./net.nix
#     ./nixos.nix
#     ./nvidia.nix
    ./steam.nix
#     ./timezone.nix
#     ./user.nix
    ./python.nix
    ./npm.nix
    ./tailscale.nix
#     ./udiskie.nix
#     ./ld.nix
    ./rust.nix
#     ./x11.nix
#     ./i3-xfce.nix
    ./ollama.nix
    ./flatpak.nix
    ./hyprland.nix
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
