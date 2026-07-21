{ ... }:
{
  services.tailscale = {
    enable = true;
    extraUpFlags = [ "--ssh" ];
  };
  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall = {
    allowedUDPPorts = [ 41641 34197 ];
    allowedTCPPorts = [ 22 4747 5030 5031 9180 3923 50300 47990 ];

    trustedInterfaces = [ "tailscale0" ];
    allowedTCPPortRanges = [
      {
        from = 3000;
        to = 8081;
      }
    ];
  };
}
