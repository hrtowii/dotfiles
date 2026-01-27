{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
  };

  environment.variables = {
    EDITOR = "nvim";
  };

  environment.shellAliases = {
    lg = "lazygit";
    ls = "eza --icons=always --color=always --hyperlink -1";
  };
}
