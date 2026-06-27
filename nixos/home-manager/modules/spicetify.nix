{ config, inputs, lib, pkgs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  stylixColors = lib.attrByPath [ "lib" "stylix" "colors" ] null config;
  stylixEnabled = lib.attrByPath [ "stylix" "enable" ] false config;
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  stylix.targets.spicetify.enable = false;

  programs.spicetify = {
    enable = true;

    enabledExtensions = with spicePkgs.extensions; [
      # adblock
      hidePodcasts
      shuffle
    ];

    theme = spicePkgs.themes.text;
    customColorScheme = lib.mkIf (stylixColors != null && stylixEnabled) (with stylixColors.withHashtag; {
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
    });
  };
}
