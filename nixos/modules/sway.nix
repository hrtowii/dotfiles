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
    package = pkgs.swayfx;
  };
  environment.systemPackages = with pkgs; [
    i3status
    swayfx
    kitty
    grim
    slurp
    wl-clipboard
    wofi
    libnotify
  ];
}
