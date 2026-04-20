{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  environment.systemPackages = with pkgs; [
    i3status
    sway
    kitty
    grim
    slurp
    wl-clipboard
  ];
}
