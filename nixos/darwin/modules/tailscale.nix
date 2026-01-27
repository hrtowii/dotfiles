{ pkgs,...}: {
  services.tailscale = {
    enable = true;
  };
    environment.systemPackages = with pkgs; [
        tailscale
    ];
}

