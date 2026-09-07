{ config, inputs, lib, pkgs, options, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  stylixImported = options ? stylix;
  stylixEnabled = stylixImported && (lib.attrByPath [ "stylix" "enable" ] false config);
  stylixScheme = with config.lib.stylix.colors; {
    accent             = base0D;
    accent-active      = base0C;
    accent-inactive    = base02;
    banner             = base0D;
    border-active      = base0C;
    border-inactive    = base03;
    header             = base03;
    highlight          = base01;
    main               = base00;
    notification       = base0D;
    notification-error = base08;
    subtext            = base04;
    text               = base05;
  };
  fallbackScheme = {
    accent             = "ea9a97";
    accent-active      = "ea9a97";
    accent-inactive    = "2a273f";
    banner             = "ea9a97";
    border-active      = "ea9a97";
    border-inactive    = "393552";
    header             = "6e6a86";
    highlight          = "44415a";
    main               = "232136";
    notification       = "3e8fb0";
    notification-error = "eb6f92";
    subtext            = "908caa";
    text               = "e0def4";
  };
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
        colorScheme = "custom";
        customColorScheme = if stylixEnabled then stylixScheme else fallbackScheme;
      };
  }

  (lib.mkIf (stylixImported && config.stylix.enable) {
    stylix.targets.spicetify.enable = false;
  })
  ];
}
