{ config, ... }:
  let configDir = ../config;
in
  {
    programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = false;
    syntaxHighlighting.enable = false;

    completionInit = ''
      autoload -Uz compinit
      setopt EXTENDEDGLOB
      if [[ -n ''${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
        compinit
      else
        compinit -C
      fi
      unsetopt EXTENDEDGLOB
    '';

    initExtra = ''
      typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

      # Make the native arm64 Homebrew at /opt/homebrew win over the
      # x86_64 (Rosetta) one at /usr/local. This puts /opt/homebrew/bin
      # ahead of /usr/local/bin so plain `brew`/`nvim` resolve to arm64.
      if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
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
