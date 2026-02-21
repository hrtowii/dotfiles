{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "htrowii";
        email = "leonghongkit@gmail.com";
      };
      url."ssh://git@github.com/".insteadOf = "https://github.com/";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
