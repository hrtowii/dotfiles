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
      description = "Wallpaper image";
    };
    duotone = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Apply duotone effect to wallpaper";
    };
    shadow = {
      hue        = lib.mkOption { type = lib.types.ints.between 0 360; default = 174; };
      saturation = lib.mkOption { type = lib.types.ints.between 0 100; default = 73;  };
      lightness  = lib.mkOption { type = lib.types.ints.between 0 100; default = 8;   };
    };
    highlight = {
      hue        = lib.mkOption { type = lib.types.ints.between 0 360; default = 6;  };
      saturation = lib.mkOption { type = lib.types.ints.between 0 100; default = 87; };
      lightness  = lib.mkOption { type = lib.types.ints.between 0 100; default = 77; };
    };
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable  = true;
      image   = if cfg.duotone then duotoneWallpaper else cfg.wallpaper;
      polarity = "dark";
      autoEnable = true;
      fonts = {
        monospace.name = "Xanh Mono";
        sizes = {
          applications = 10;
          desktop      = 10;
          popups       = 10;
          terminal     = 14;
        };
      };
      cursor = {
        name    = "Vanilla-DMZ-AA";
        package = pkgs.vanilla-dmz;
        size    = 24;
      };
      targets = {
        gtk.enable      = true;
        qt.enable       = false;
	qt.platform      = "kde";
	# ^^ this is needed so kde doesnt fuckin kill itself with kvantum
	# Stylix defaults to using Kvantum to theme Qt apps, but on Plasma 6
# Kvantum is NOT a valid QtQuickControls2 style — Plasma's shell (panels,
# wallpaper, widget explorer, etc.) is QML/QQC2, not plain QWidgets.
# autoEnable pulls this in even with `qt.enable = false`, because Plasma
# theming is driven by a separate KDE-platform path, not the standalone
# qt target. Result: plasmashell loads but every QML surface fails with
# `module "kvantum" is not installed`, so you get no wallpaper, no panels,
# no desktop — apps still launch fine since they don't need QQC2.
#
# Setting `qt.platform = "kde"` tells Stylix to theme Plasma through its
# native kdeglobals/color-scheme mechanism instead of generating a Kvantum
# theme and expecting Plasma to use it as its QQC2 style.
#
# Upstream tracking: https://github.com/nix-community/stylix/issues/835
# (reopened — the "kde" platform fixes the shell but has been reported to
# break bits of System Settings; a proper `kde6` platform option landed
# via home-manager#6493 / nixpkgs#384669, so if flake inputs are updated
# past that, re-check whether this override is still the best fix)
        spicetify.enable = false;
      };
    };
  };
}
