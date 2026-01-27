{ programs.git = {
    enable = true;
    userName = "htrowii";
    userEmail = "leonghongkit@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      url."ssh://git@github.com/".insteadOf = "https://github.com/";
    };
  };
}

