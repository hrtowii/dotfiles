{ config, pkgs, inputs, ... }:

{
    programs.hyprland = {
        enable = true;
    };

    environment.systemPackages = with pkgs; [
      libnotify
      qt5.qtwayland
      qt6.qtwayland
      wl-clipboard
      wofi
      waybar
      hyprshot
      wbg
      # inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww
    ];
}
