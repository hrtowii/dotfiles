{ config, lib, pkgs, ... }:

let
  customFontsDir = ../../home-manager/fonts;
in
{
  fonts.fontconfig.enable = true;

  home.activation = lib.hm.dag.entryAfter ["writeBoundary"] ''
    dst="${config.home.homeDirectory}/Library/Fonts/HomeManagerPrivate"

    mkdir -p "$dst"

    find "$dst" -type f -delete

    cp -a --verbose ${customFontsDir}/. "$dst"/

    # atsutil databases -removeUser >/dev/null 2>&1 || true
  '';
}
