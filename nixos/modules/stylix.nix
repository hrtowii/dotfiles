{ pkgs, inputs, config, lib, ... }:
let
  cfg = config.stylixDuotone;
  duotoneWallpaper = pkgs.runCommand "duotone-wallpaper.png" {
    nativeBuildInputs = [ pkgs.imagemagick ];
    src = cfg.wallpaper;
  } ''
    convert $src -colorspace gray \
      \( -size 1x256 gradient:"hsl(${toString cfg.shadow.hue},${toString cfg.shadow.saturation}%,${toString cfg.shadow.lightness}%)"-"hsl(${toString cfg.highlight.hue},${toString cfg.highlight.saturation}%,${toString cfg.highlight.lightness}%)" \) \
      -clut png:$out
  '';
in {
  imports = [ inputs.stylix.nixosModules.stylix ];

  options.stylixDuotone = {
    enable = lib.mkEnableOption "duotone wallpaper processing";

    wallpaper = lib.mkOption {
      type = lib.types.path;
      description = "Wallpaper image to apply duotone effect to";
    };

    shadow = {
      hue = lib.mkOption {
        type = lib.types.ints.between 0 360;
        default = 174;
      };
      saturation = lib.mkOption {
        type = lib.types.ints.between 0 100;
        default = 73;
      };
      lightness = lib.mkOption {
        type = lib.types.ints.between 0 100;
        default = 8;
      };
    };

    highlight = {
      hue = lib.mkOption {
        type = lib.types.ints.between 0 360;
        default = 6;
      };
      saturation = lib.mkOption {
        type = lib.types.ints.between 0 100;
        default = 87;
      };
      lightness = lib.mkOption {
        type = lib.types.ints.between 0 100;
        default = 77;
      };
    };
  };

  config = {
    stylixDuotone = {
      enable = true;
      wallpaper = ../home-manager/config/wallpapers/kogecha.jpg;
    };
    stylix = {
      enable = true;
      image = if cfg.enable then duotoneWallpaper else cfg.wallpaper;
      polarity = "dark";
      # opacity = {
      #   terminal = 0.95;
      # };
      autoEnable = true;
      fonts = {
        monospace = {
          name = "Berkeley Mono Nerd Font";
        };
        sizes = {
          applications = 10;
          desktop = 10;
          popups = 10;
          terminal = 12;
        };
      };

      cursor = {
        name = "Vanilla-DMZ-AA";
        package = pkgs.vanilla-dmz;
        size = 24;
      };

      targets = {
        gtk.enable = true;
        qt.enable = false;
	spicetify.enable = false;
      };
    };
  };
}
