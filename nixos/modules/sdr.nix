{ config, pkgs, ... }:
{
  boot.kernelParams = [ "modprobe.blacklist=dvb_usb_rtl28xxu" ]; # blacklist this module
  hardware.rtl-sdr.enable = true;
  users.users.venti.extraGroups = [ "plugdev" ];
  environment.systemPackages = with pkgs; [
    wget
    vim
    libusb1
    usbutils
    rtl-sdr
    gqrx
    soapysdr
    soapymiri
  ];
}
