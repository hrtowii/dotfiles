{ config, lib, pkgs, ... }:
# hack to copy fonts from my home manager to Library/Fonts, normal symlink wont work
let
  customFontsDir = ../../home-manager/fonts;
in
{
  fonts.fontconfig.enable = true;

  home.activation.copyPrivateFonts = lib.hm.dag.entryAfter ["writeBoundary"] ''
    dst="${config.home.homeDirectory}/Library/Fonts/HomeManagerPrivate"

    mkdir -p "$dst"

    sudo find "$dst" -type f -delete

    sudo cp -a ${customFontsDir}/. "$dst"/

    sudo atsutil databases -removeUser >/dev/null 2>&1 || true
  '';
}
