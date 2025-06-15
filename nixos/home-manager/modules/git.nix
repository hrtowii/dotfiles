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
      init.defaultBranch = "main";
      pull.rebase = true;

      # SSH transport configuration (default to personal)
      core.sshCommand = "ssh -i ~/.ssh/id_rsa_personal";

      # URL rewriting for different GitHub accounts
      url = {
        "git@github-personal:" = {
          insteadOf = "https://github.com/hrtowii/";
        };
        "git@github-work:" = {
          insteadOf = "https://github.com/hrtowii/";
        };
      };


    };
  };
}
