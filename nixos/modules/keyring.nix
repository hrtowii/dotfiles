{ pkgs, config, lib, ... }:
# https://nixos.wiki/wiki/GNOME#Running_GNOME_programs_outside_of_GNOME
with lib;
let cfg = config.jd.gnome;
in {
  options.jd.gnome = {
    enable = mkOption {
      description = "Enable GNOME programs";
      type = types.bool;
      default = false;
    };

    keyring = {
      enable = mkOption {
        description = "Enable gnome-keyring";
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.dconf.enable = true;
      # Fixes the org.a11y.Bus not provided by .service file error
      services.gnome.at-spi2-core.enable = true;
    }
    (mkIf cfg.keyring.enable {
      environment.systemPackages = [ pkgs.libsecret ];
      services.gnome.gnome-keyring.enable = true;
      services.dbus.packages = [ pkgs.seahorse ];
    })
  ]);
}