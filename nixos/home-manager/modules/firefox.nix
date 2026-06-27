{
  config,
  pkgs,
  lib,
  ...
}: {
  stylix.targets.firefox.profileNames = [ "ff" ];

  programs.firefox = {
    enable = true;
    profiles = {
      ff = {
        isDefault = true;
        name = "ff";
        path = "ff.default";
        userChrome = builtins.readFile ../config/firefox/userChrome.css;
        userContent = builtins.readFile ../config/firefox/userContent.css;
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
      };
    };
  };
}
