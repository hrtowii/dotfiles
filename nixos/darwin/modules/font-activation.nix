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
      cp -r ${customFontsDir}/. "$dst"/
      find "$dst" -type f -exec chmod 644 {} \;
      chmod 755 "$dst"
      # `cp` from the nix store carries the 1970 epoch mtime; bump it so fontd
      # notices the directory changed and re-scans.
      touch "$dst"

      # Force the font registry to re-index.
      #
      # Do NOT use `atsutil databases -remove`: on macOS 14+ it deletes the
      # FontRegistry cache out from under the still-running fontd, which then
      # keeps serving a now-missing database and PERMANENTLY wedges font
      # registration (every font in ~/Library/Fonts and /Library/Fonts silently
      # disappears). The correct refresh is to drop the cache and restart both
      # the registry daemon (fontd) and its worker so they rebuild cleanly.
      find /var/folders -maxdepth 4 -type d -name com.apple.FontRegistry \
        -exec rm -rf {} + 2>/dev/null || true
      killall fontd fontworker 2>/dev/null || true
    '';

    serviceConfig = {
      RunAtLoad = true;
      StandardOutPath = "/var/log/copyHomeManagerFonts.log";
      StandardErrorPath = "/var/log/copyHomeManagerFonts.log";
    };
  };
}
