{
  pkgs,
  inputs,
  vars,
  hostVars,
  ...
}:
{
  imports = [
    ./modules/discord.nix
    ./modules/nvim.nix
    ./modules/starship.nix
    ./modules/vscode.nix
    ./modules/zed.nix
    ./modules/zellij.nix
    ./modules/obsidian.nix
    ./modules/git.nix
    ./modules/gtk.nix
    ./modules/fonts.nix
    ./modules/firefox.nix
    ./modules/spicetify.nix
    ./modules/osu.nix
    ./modules/whatsapp.nix
    ./modules/waybar.nix
    ./modules/swaync.nix
    ./modules/art_daemon.nix
    ./modules/qbittorrent.nix
    # ./modules/chrome.nix
    ./config.nix
  ];

  home.username = hostVars.username;
  home.homeDirectory = "${hostVars.homePrefix}/${hostVars.username}";
  home.stateVersion = hostVars.stateVersion;
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
    p7zip
    file
  ];
}
