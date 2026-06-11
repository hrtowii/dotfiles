# hosts that import this run harmonia and serve their own /nix/store,
# signing under their own hostname. The central cache that other hosts push to
# and pull from is vars.cache.host; the consumer/push side lives in
{ pkgs, config, vars, ... }:
let
  keyName = config.networking.hostName;
  keyDir = "/var/lib/harmonia";
  privKey = "${keyDir}/cache-priv-key.pem";
  pubKey = "${keyDir}/cache-pub-key.pem";
  port = vars.cache.port;
in
{
  services.harmonia.cache = {
    enable = true;
    signKeyPaths = [ privKey ];
    settings.bind = "[::]:${toString port}";
  };

  nix.settings.trusted-users = [ "root" "@wheel" vars.cache.user ];

  systemd.services.harmonia-keygen = {
    description = "Generate harmonia binary cache signing key";
    wantedBy = [ "multi-user.target" ];
    before = [ "harmonia.service" ];
    path = [ pkgs.nix ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      if [ ! -f "${privKey}" ]; then
        mkdir -p "${keyDir}"
        nix-store --generate-binary-cache-key "${keyName}" "${privKey}" "${pubKey}"
        chmod 600 "${privKey}"
        chmod 644 "${pubKey}"
      fi
    '';
  };

  systemd.services.harmonia = {
    after = [ "harmonia-keygen.service" ];
    wants = [ "harmonia-keygen.service" ];
  };
  # tailscale only
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ port ];
}
