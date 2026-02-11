{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "htrowii";
    userEmail = "leonghongkit@gmail.com";
    extraConfig = {
      url."ssh://git@github.com/".insteadOf = "https://github.com/";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
