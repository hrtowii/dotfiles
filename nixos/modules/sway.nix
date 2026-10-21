{
  config,
  pkgs,
  lib,
  hostVars,
  ...
}:
let
  stylixEnabled = lib.attrByPath [ "stylix" "enable" ] false config;
  fontName = font:
    if font.name != null then font.name else config.stylix.fonts.monospace.name;
in
{
  config = {
xdg.portal = {
  enable = true;
  wlr.enable = true;
  extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];

  config = {
    common.default = [ "gtk" ];
    sway.default = lib.mkForce [ "wlr" "gtk" ];
    KDE.default = [ "kde" ];
  };
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
    home-manager.users.${hostVars.username} = {
      home.file.".config/sway/config" =
        lib.mkIf (!stylixEnabled) {
          source = lib.mkDefault ../home-manager/config/i3/config;
        };
      wayland.windowManager.sway = {
        enable = stylixEnabled;
        checkConfig = false;
        config = {
          fonts = if stylixEnabled
            then {
              names = lib.mkForce [ (fontName config.stylixConfig.fonts.sway) ];
              size = lib.mkForce (config.stylixConfig.fonts.sway.size * 1.0);
            }
            else {
              names = [ "Cohere Mono" ];
              size = 8.0;
            };
          keybindings = lib.mkIf stylixEnabled (lib.mkForce { });
          modes = lib.mkIf stylixEnabled (lib.mkForce { });
          bars = lib.mkIf stylixEnabled (lib.mkForce [
            {
              command = "${pkgs.sway}/bin/swaybar";
              statusCommand = "${pkgs.i3status}/bin/i3status";
              fonts = {
                names = [ (fontName config.stylixConfig.fonts.i3status) ];
                size = config.stylixConfig.fonts.i3status.size * 1.0;
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
  };
}
