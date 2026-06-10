{
  pkgs,
  inputs,
  vars,
  hostVars,
  ...
}:
{
  imports = [
    ../../../home-manager/modules/discord.nix
    ../../../home-manager/modules/nvim.nix
    ../../../home-manager/modules/starship.nix
    ../../../home-manager/modules/zed.nix
    ../../../home-manager/modules/zellij.nix
    ../../../home-manager/modules/obsidian.nix
    ../../../home-manager/modules/git.nix
    ../../../home-manager/modules/gtk.nix
    ../../../home-manager/modules/fonts.nix
    ../../../home-manager/modules/firefox.nix
    ../../../home-manager/modules/spicetify.nix
    ../../../home-manager/modules/osu.nix
    ../../../home-manager/modules/swaync.nix
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
    catppuccin-cursors.macchiatoBlue
    catppuccin-gtk
    papirus-folders
    material-symbols
    nerd-fonts.jetbrains-mono
    ibm-plex
    oh-my-zsh
    eza
    statix
  ];
}
