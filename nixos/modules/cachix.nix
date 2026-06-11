# Self-hosted Nix binary cache via harmonia, served to the tailnet.
{ pkgs, ... }:
let
  keyName = "linux";
  keyDir = "/var/lib/harmonia";
  privKey = "${keyDir}/cache-priv-key.pem";
  pubKey = "${keyDir}/cache-pub-key.pem";
  port = 6767;
in
{
  services.harmonia.cache = {
    enable = true;
    signKeyPaths = [ privKey ];
    settings.bind = "[::]:${toString port}";
  };

  nix.settings.trusted-users = [ "root" "@wheel" ];

  # harmonia won't create its own signing key, so generate one on first boot.
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

  # Bound to all interfaces, but only reachable over tailscale.
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ port ];
}
