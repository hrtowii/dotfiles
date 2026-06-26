{ config, lib, ... }:
let
  stylixColors = lib.attrByPath [ "lib" "stylix" "colors" ] null config;
  stylixEnabled = lib.attrByPath [ "stylix" "enable" ] false config;

  colorDefs = if stylixColors != null && stylixEnabled then
    with stylixColors.withHashtag; ''
      @define-color base00 ${base00}; @define-color base01 ${base01};
      @define-color base02 ${base02}; @define-color base03 ${base03};
      @define-color base04 ${base04}; @define-color base05 ${base05};
      @define-color base06 ${base06}; @define-color base07 ${base07};
      @define-color base08 ${base08}; @define-color base09 ${base09};
      @define-color base0A ${base0A}; @define-color base0B ${base0B};
      @define-color base0C ${base0C}; @define-color base0D ${base0D};
      @define-color base0E ${base0E}; @define-color base0F ${base0F};
    ''
  else
    ''
      @define-color base00 #191724; @define-color base01 #1f1d2e;
      @define-color base02 #26233a; @define-color base03 #6e6a86;
      @define-color base04 #908caa; @define-color base05 #e0def4;
      @define-color base06 #e0def4; @define-color base07 #e0def4;
      @define-color base08 #eb6f92; @define-color base09 #f6c177;
      @define-color base0A #ebbcba; @define-color base0B #31748f;
      @define-color base0C #9ccfd8; @define-color base0D #c4a7e7;
      @define-color base0E #c4a7e7; @define-color base0F #e0def4;
    '';

  customCss = builtins.readFile ../config/swaync/style.css;
in {
  stylix.targets.swaync.enable = false;

  services.swaync = {
    enable = true;

    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-layer = "top";
      layer-shell = true;
      cssPriority = "application";
      control-center-margin-top = 0;
      control-center-margin-bottom = 0;
      control-center-margin-right = 0;
      control-center-margin-left = 0;
      notification-2fa-action = true;
      notification-inline-replies = false;
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;
      fit-to-screen = true;
      control-center-width = 500;
      control-center-height = 600;
      notification-window-width = 500;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = false;
      hide-on-action = true;
      script-fail-notify = false;
    };

    style = colorDefs + customCss;
  };
}
