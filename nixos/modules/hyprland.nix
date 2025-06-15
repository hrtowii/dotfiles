{ config, pkgs, ... }:

{
    programs.hyprland = {
        enable = true;
    };

    environment.systemPackages = with pkgs; [
      hyprpaper
      libnotify
      mako
      qt5.qtwayland
      qt6.qtwayland
      swayidle
      swaylock-effects
      wlogout
      wl-clipboard
      wofi
      waybar
    ];
}
