{ config, pkgs, lib, ... }:

{
  home.username = "ibarahime";
  home.homeDirectory = "/Users/ibarahime";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "htrowii";
    userEmail = "leonghongkit@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      url."ssh://git@github.com/".insteadOf = "https://github.com/";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = false;
    syntaxHighlighting.enable = false;

    initExtra = ''
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      if [ -f /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme ]; then
        source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
      fi

      if [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
        source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      fi
      if [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      fi

      if [ -f "${config.home.homeDirectory}/dev/dotfiles-nix-darwin/home/.zshrc" ]; then
        source "${config.home.homeDirectory}/dev/dotfiles-nix-darwin/home/.zshrc"
      fi
    '';
  };

  # Stow-like symlinks for dotfiles in this worktree
  # Uses mkOutOfStoreSymlink for out-of-store symlinks (changes reflected immediately)
  home.file = {
    ".config/aerospace".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/dotfiles-nix-darwin/home/.config/aerospace";
    ".config/btop".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/dotfiles-nix-darwin/home/.config/btop";
    ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/dotfiles-nix-darwin/home/.config/ghostty";
    ".config/helix".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/dotfiles-nix-darwin/home/.config/helix";
    ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/dotfiles-nix-darwin/home/.config/kitty";
    ".config/ncspot".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/dotfiles-nix-darwin/home/.config/ncspot";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/dotfiles-nix-darwin/home/.config/nvim";
    ".config/sketchybar".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/dotfiles-nix-darwin/home/.config/sketchybar";
    ".config/skhd".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/dotfiles-nix-darwin/home/.config/skhd";
    ".config/spicetify".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/dotfiles-nix-darwin/home/.config/spicetify";
    ".config/spotify-player".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/dotfiles-nix-darwin/home/.config/spotify-player";
    ".config/wezterm".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/dotfiles-nix-darwin/home/.config/wezterm";
    ".config/yabai".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/dotfiles-nix-darwin/home/.config/yabai";
    ".config/zellij".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/dotfiles-nix-darwin/home/.config/zellij";
  };

  # Minimal packages (you manage the rest via Homebrew)
  home.packages = [ ];
}
