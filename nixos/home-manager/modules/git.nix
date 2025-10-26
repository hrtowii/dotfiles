{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.git = {
    enable = true;
    extraConfig = {
      url."ssh://git@github.com/".insteadOf = "https://github.com/";
    };
    settings = {
      user = {
        name = "htrowii";
        email = "leonghongkit@gmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
