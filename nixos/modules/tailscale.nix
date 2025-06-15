{...}: {
  services.tailscale = {
    enable = true;
  };

  networking.firewall = {
    allowedUDPPorts = [41641];
    trustedInterfaces = ["tailscale0"];
  };
}
