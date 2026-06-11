{ config, lib, vars, ... }:
let
  cache = vars.cache;
in
lib.mkIf (config.networking.hostName != cache.host) {
  nix.settings = {
    substituters = [ "http://${cache.host}:${toString cache.port}" ];
    trusted-public-keys = [ cache.publicKey ];
  };
}
