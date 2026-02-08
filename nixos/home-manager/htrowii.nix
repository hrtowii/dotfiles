{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./modules/discord.nix
    # ./modules/ghostty.nix
    ./modules/nvim.nix
    ./modules/starship.nix
    ./modules/vscode.nix
    ./modules/zed.nix
    ./modules/zellij.nix
    ./modules/obsidian.nix
    ./modules/git.nix
    # ./modules/helix.nix
    ./modules/gtk.nix
    ./modules/fonts.nix
    ./modules/firefox.nix
    ./modules/spicetify.nix
    ./modules/osu.nix
    # ./modules/zen.nix
    ./modules/caelestia.nix
    ./modules/quickshell.nix
    ./config.nix
  ];

  home.username = "venti";
  home.homeDirectory = "/home/venti";
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
  home.enableNixpkgsReleaseCheck = false;
  programs.fzf.enableZshIntegration = true;
  xdg.mime.enable = false;
  programs.nix-index.enable = true;
  programs.command-not-found.enable = false;
  home.shell.enableZshIntegration = true;
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
    catppuccin-cursors.mochaDark
    catppuccin-gtk
    papirus-folders
    material-symbols
    nerd-fonts.jetbrains-mono
    ibm-plex
    oh-my-zsh
    eza
    fastfetch
    zoxide
    telegram-desktop
    beekeeper-studio
  ];
}
