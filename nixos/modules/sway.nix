{
  config,
  pkgs,
  lib,
  hostVars,
  ...
}:
{
  config = {
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };
  systemd.user.services.xdg-desktop-portal-wlr.environment = {
  WLR_DRM_NO_MODIFIERS = "1";
};
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
    environment.systemPackages = with pkgs; [
      i3status
      kitty
      grim
      slurp
      wl-clipboard
      wofi
      libnotify
    ];
    home-manager.users.${hostVars.username}.wayland.windowManager.sway = {
      enable = true;
      checkConfig = false;
      config = {
        fonts = if (config ? stylix && config.stylix.enable)
          then {
            names = [ config.stylix.fonts.monospace.name ];
            size = config.stylix.fonts.sizes.applications * 1.0;
          }
          else {
            names = [ "Cohere Mono" ];
            size = 8.0;
          };
        keybindings = lib.mkIf (config ? stylix && config.stylix.enable) (lib.mkForce { });
        modes = lib.mkIf (config ? stylix && config.stylix.enable) (lib.mkForce { });
        bars = lib.mkIf (config ? stylix && config.stylix.enable) (lib.mkForce [
          {
            command = "${pkgs.sway}/bin/swaybar";
            statusCommand = "${pkgs.i3status}/bin/i3status";
            fonts = {
              names = [ config.stylix.fonts.monospace.name ];
              size = 10.0;
            };
	    colors = let
      c = config.lib.stylix.colors;
    in {
      background = "#${c.base00}";
      statusline = "#${c.base05}";
      separator  = "#${c.base03}";
      focusedWorkspace = {
        background = "#${c.base0D}";
        border     = "#${c.base0D}";
        text       = "#${c.base00}";
      };
      activeWorkspace = {
        background = "#${c.base03}";
        border     = "#${c.base03}";
        text       = "#${c.base05}";
      };
      inactiveWorkspace = {
        background = "#${c.base00}";
        border     = "#${c.base00}";
        text       = "#${c.base03}";
      };
      urgentWorkspace = {
        background = "#${c.base08}";
        border     = "#${c.base08}";
        text       = "#${c.base00}";
      };
      };
          }
        ]);
      };
      extraConfig = builtins.readFile ../home-manager/config/i3/config-stylix;
    };
  };
}
