# make sure i dont collide w tailscale ports
{ pkgs, ... }:
{
  # /etc/wireguard/wg1-private.key and /etc/wireguard/wg1-psk
  # to exist with mode 0600 chown root

  networking.wireguard.enable = true;

  networking.wg-quick.interfaces.wg1 = {
    address = [ "10.8.0.13/32" ];
    dns = [ "10.10.10.102" ];
    mtu = 1420;
    privateKeyFile = "/etc/wireguard/wg1-private.key";

    peers = [
      {
        publicKey = "W5pgXlv2h9qHiBjK7IgeHz75N6lzCZAhOMtdgNeeMWw=";
        presharedKeyFile = "/etc/wireguard/wg1-psk";
        endpoint = "therealoranges.com:57438";
        allowedIPs = [ "0.0.0.0/0" ];
        persistentKeepalive = 25;
      }
    ];
  };
}
