{
  config,
  pkgs,
  lib,
  ...
}:
{  options.npm.enable = lib.mkEnableOption "system-wide npm environment";

  config = lib.mkIf config.npm.enable {
    environment.systemPackages = with pkgs; [
    nodejs
    claude-code
    opencode
      # nodejs_24 im not rebuilding u every time bro
      # nodePackages.npm
      bun
      # nodePackages.typescript
      # nodePackages.prettier
      # nodePackages.eslint
      # nodePackages.sql-formatter
      # nodePackages.markdownlint-cli
      # nodePackages.stylelint
      # nodePackages.htmlhint
    ];

    # environment.sessionVariables.PATH =
    #   lib.mkAfter ":${"$"}{HOME}/.npm-global/bin";
    #
    # environment.etc."npmrc".source = npmConf;

    # systemd.user.services."npm-setup" = {
    #   description = "Install .npmrc";
    #   wantedBy = ["default.target"];
    #   script = ''
    #     install -m600 -D ${npmConf} "$HOME/.npmrc"
    #   '';
    #   serviceConfig.Type = "oneshot";
    # };
  };
}

