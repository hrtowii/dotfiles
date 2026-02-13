{ config, pkgs, ... }:
{
  boot.kernelParams = [ 
  "modprobe.blacklist=dvb_usb_rtl28xxu"
  "modprobe.blacklist=msi001"
  "modprobe.blacklist=msi2500"
  ]; # blacklist this module
  hardware.rtl-sdr.enable = true;
  users.users.venti.extraGroups = [ "plugdev" ];
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
  ];
}
