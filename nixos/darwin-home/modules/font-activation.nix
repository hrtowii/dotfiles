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

    find "$dst" -type f -delete

    cp -r ${customFontsDir}/. "$dst"/
    find "$dst" -type f -exec chmod 644 {} \;
    chmod 755 "$dst"
    touch "$dst"

    launchctl kickstart -k gui/$(id -u)/com.apple.FontWorker 2>/dev/null || true
  '';
}
