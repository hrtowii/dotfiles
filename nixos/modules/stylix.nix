{ pkgs, inputs, config, lib, ... }:
let
  cfg = config.stylixConfig;
  fontOptions = defaultName: defaultPackage: {
    name = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = defaultName;
      description = "Font family name; null inherits the Stylix default.";
    };
    package = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = defaultPackage;
      description = "Optional package providing the font.";
    };
  };
  sizeOption = default: lib.mkOption {
    type = lib.types.nullOr lib.types.numbers.positive;
    inherit default;
    description = "Font size in points; null inherits the Stylix default.";
  };
  specified = lib.filterAttrs (_: value: value != null);
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

  options.stylixConfig = {
    enable = lib.mkEnableOption "Stylix configuration";
    wallpaper = lib.mkOption {
      type = lib.types.path;
      description = "Wallpaper image";
    };
    duotone = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Apply duotone effect to wallpaper";
    };
    fonts = {
      monospace = fontOptions "Recursive Mono Linear Static" null;
      serif = fontOptions "Michelangelus" null;
      sansSerif = fontOptions "Aporetic Sans" null;
      emoji = fontOptions null null;
      sizes = {
        applications = sizeOption null;
        desktop = sizeOption 12;
        popups = sizeOption 12;
        terminal = sizeOption 12;
      };
      sway = (fontOptions "Cohere Mono" null) // {
        size = lib.mkOption {
          type = lib.types.numbers.positive;
          default = 8;
          description = "Sway window title font size in points.";
        };
      };
      i3status = (fontOptions cfg.fonts.monospace.name cfg.fonts.monospace.package) // {
        size = lib.mkOption {
          type = lib.types.numbers.positive;
          default = 10;
          description = "Font size in points for the Sway bar displaying i3status.";
        };
      };
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

  config = lib.mkMerge [
    {
      # Niri's integration also needs these options when system theming is off.
      home-manager.sharedModules = lib.mkIf (!config.stylix.enable) [
        inputs.stylix.homeModules.stylix
      ];
    }
    (lib.mkIf cfg.enable {
    fonts.packages = lib.filter (package: package != null) [
      cfg.fonts.sway.package
      cfg.fonts.i3status.package
    ];
    stylix = {
      enable  = true;
      image   = if cfg.duotone then duotoneWallpaper else cfg.wallpaper;
      polarity = "dark";
      autoEnable = true;
      fonts = {
        monospace = specified cfg.fonts.monospace;
        serif = specified cfg.fonts.serif;
        sansSerif = specified cfg.fonts.sansSerif;
        emoji = specified cfg.fonts.emoji;
        sizes = specified cfg.fonts.sizes;
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
    })
  ];
}
