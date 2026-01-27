{ config, pkgs, lib, ... }:

let configDir = ./config;
in
{
  imports = [
  ./config.nix
];
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

      if [ -f "${configDir}/zsh/.zshrc" ]; then
        source "${configDir}/zsh/.zshrc"
      fi
    '';
  };

  home.packages = [ ];
}
