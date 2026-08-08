{ pkgs, ... }:

{
  networking.nftables.enable = true;

  networking.nftables.ruleset = ''
    table inet tailscale-bypass {
      set tailscaled {
        type cgroupsv2
      }

      chain output {
        type route hook output priority mangle; policy accept;

        socket cgroupv2 level 2 @tailscaled \
          meta mark set 0x40000
      }
    }
  '';

  systemd.services.tailscaled.serviceConfig.NFTSet =
    "cgroup:inet:tailscale-bypass:tailscaled";

  networking.iproute2 = {
    enable = true;
  };

  systemd.services.tailscale-routing-bypass = {
    description = "Route tailscaled traffic outside WireGuard";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-pre.target" ];
    before = [ "network.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;

      ExecStart = pkgs.writeShellScript "tailscale-routing-bypass" ''
        ${pkgs.iproute2}/bin/ip rule add \
          priority 100 \
          fwmark 0x40000/0xff0000 \
          lookup main

        ${pkgs.iproute2}/bin/ip -6 rule add \
          priority 100 \
          fwmark 0x40000/0xff0000 \
          lookup main
      '';

      ExecStop = pkgs.writeShellScript "tailscale-routing-bypass-cleanup" ''
        ${pkgs.iproute2}/bin/ip rule del \
          priority 100 \
          fwmark 0x40000/0xff0000 \
          lookup main || true

        ${pkgs.iproute2}/bin/ip -6 rule del \
          priority 100 \
          fwmark 0x40000/0xff0000 \
          lookup main || true
      '';
    };
  };
}
