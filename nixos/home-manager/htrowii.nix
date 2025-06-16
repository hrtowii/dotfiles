{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./modules/discord.nix
    ./modules/ghostty.nix
    ./modules/nvim.nix
    ./modules/starship.nix
    # ./modules/vscode.nix
    ./modules/zed.nix
    ./modules/zellij.nix
    ./modules/obsidian.nix
    ./modules/git.nix
    # ./modules/helix.nix
    ./modules/gtk.nix
    ./modules/fonts.nix
    ./modules/firefox.nix
    ./modules/spicetify.nix
    ./config/quickshell
    #./config/unused/hypr/default.nix
    ./config.nix
  ];

  home.username = "htrowii";
  home.homeDirectory = "/home/htrowii";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
  home.enableNixpkgsReleaseCheck = false;
  xdg.mime.enable = false;
  home.packages = with pkgs; [
    coreutils
    gnused
    findutils
    yazi
    htop
    btop
    arandr
    wev
    fish
    catppuccin-cursors.macchiatoBlue
    catppuccin-gtk
    papirus-folders
    material-symbols
    nerd-fonts.jetbrains-mono
    ibm-plex
    oh-my-zsh
    eza
  ];

}
