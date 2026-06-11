# push every successful build to the central cache via a post-build-hook to linux host
{ config, lib, pkgs, vars, ... }:
let
  cfg = config.cachePush;
  cache = vars.cache;
  target = "ssh-ng://${cache.user}@${cache.host}";
  push = pkgs.writeShellScript "push-to-cache" ''
    set -uf
    export IFS=' '
    export NIX_SSHOPTS="-o BatchMode=yes -o ConnectTimeout=2 -o StrictHostKeyChecking=accept-new"
    ${pkgs.nix}/bin/nix copy --no-check-sigs --to "${target}" $OUT_PATHS || true
  '';
in
{
  options.cachePush.enable =
    lib.mkEnableOption "auto-push successful builds to the central binary cache";

  config = lib.mkIf (cfg.enable && config.networking.hostName != cache.host) {
    nix.settings.post-build-hook = "${push}";
  };
}
