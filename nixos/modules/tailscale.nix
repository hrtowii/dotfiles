{ ... }:
{
  services.tailscale = {
    enable = true;
  };

  networking.firewall = {
    allowedUDPPorts = [ 41641 ];
    trustedInterfaces = [ "tailscale0" ];
    allowedTCPPortRanges = [
      {
        from = 3000;
        to = 8081;
      }
    ];
  };
}
