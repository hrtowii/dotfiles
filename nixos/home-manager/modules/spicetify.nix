{ config, inputs, lib, pkgs, options, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  stylixImported = options ? stylix;
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  config = lib.mkMerge [
    {
      programs.spicetify = {
        enable = true;

        enabledExtensions = with spicePkgs.extensions; [
          hidePodcasts
          shuffle
        ];

        theme = spicePkgs.themes.text;

        customColorScheme = lib.mkIf (stylixImported && config.stylix.enable) (
          with config.lib.stylix.colors.withHashtag; {
            accent             = base0D;
            accent-active      = base0C;
            accent-inactive    = base03;
            banner             = base0D;
            border-active      = base0C;
            border-inactive    = base03;
            header             = base04;
            highlight          = base02;
            main               = base00;
            notification       = base0D;
            notification-error = base08;
            subtext            = base04;
            text               = base05;
          }
        );
      };
  }

  (lib.mkIf (stylixImported && config.stylix.enable) {
    stylix.targets.spicetify.enable = false;
  })
  ];
}
