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
      package = pkgs.swayfx;
      checkConfig = false;
      config = lib.mkIf (config ? stylix && config.stylix.enable) {
        keybindings = lib.mkForce { };
        modes = lib.mkForce { };
        bars = lib.mkForce [
            {
              command = "${pkgs.swayfx}/bin/swaybar";
              statusCommand = "${pkgs.i3status}/bin/i3status";
              fonts = {
                names = [ "Cohere Mono" ];
                size = 8.0;
              };
            }
        ];
      };
      extraConfig =
        builtins.readFile ../home-manager/config/swayfx/config
        + lib.optionalString (config ? stylix && config.stylix.enable) ''
          shadows enable
          shadow_color ${config.lib.stylix.colors.withHashtag.base01}
          shadow_blur_radius 30
          shadow_offset 2 2
        '';
    };
  };
}
