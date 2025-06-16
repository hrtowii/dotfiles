# ZSH settings
# https://github.com/rubyowo/dotfiles/blob/123af0706e540911da2764cb6555ad2b2dea7591/users/rei/apps/zsh.nix
{ pkgs
, ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    # Aliases
    shellAliases = {
      lg = "lazygit";
      nix-clean = "sudo nix-collect-garbage";
      cpf = "wl-copy <";
    };
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "sudo"
      ];
    };
  };
}
