{
  config,
  pkgs,
  lib,
  hostVars,
  ...
}:
{
  config = {
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
    home-manager.users.${hostVars.username}.wayland.windowManager.sway = {
      enable = true;
      config = lib.mkIf (config ? stylix && config.stylix.enable) {
        keybindings = lib.mkForce { };
        modes = lib.mkForce { };
        bars = lib.mkForce [ ];
      };
      extraConfig = builtins.readFile ../home-manager/config/swayfx/config;
    };
  };
}
