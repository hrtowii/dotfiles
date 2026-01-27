{ programs.git = {
    enable = true;
    settings = {
      user = {
        name = "htrowii";
        email = "leonghongkit@gmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      url."ssh://git@github.com/".insteadOf = "https://github.com/";
    };
  };
}

