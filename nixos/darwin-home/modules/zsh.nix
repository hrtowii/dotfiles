{ config, ... }:
  let configDir = ../config;
in
  {
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
}
