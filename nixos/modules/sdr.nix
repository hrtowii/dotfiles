{ config, pkgs, hostVars, ... }:
{
  boot.kernelParams = [ 
  "modprobe.blacklist=dvb_usb_rtl28xxu"
  "modprobe.blacklist=msi001"
  "modprobe.blacklist=msi2500"
  ]; # blacklist this module
  hardware.rtl-sdr.enable = true;
  users.users.${hostVars.username}.extraGroups = [ "plugdev" ];
  environment.systemPackages = with pkgs; [
    wget
    vim
    libusb1
    usbutils
    rtl-sdr
    gqrx
    cubicsdr
    # soapysdr
    soapysdr-with-plugins
    soapymiri
    # osmo-tetra.osmo-tetra-sq5bpf-2
    # osmo-tetra.libosmocore-sq5bpf
  ];
}
