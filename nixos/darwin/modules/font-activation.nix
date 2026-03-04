{ config, pkgs, ... }:

let
  customFontsDir = ../../home-manager/fonts;
in
{
  launchd.daemons.copyHomeManagerFonts = {
    script = ''
      dst="/Library/Fonts/HomeManagerPrivate"

      mkdir -p "$dst"
      find "$dst" -type f -delete
      cp -a ${customFontsDir}/. "$dst"/

      atsutil databases -remove
    '';

    serviceConfig = {
      RunAtLoad = true;
    };
  };
}
