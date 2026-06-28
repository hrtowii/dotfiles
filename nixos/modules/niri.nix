{ inputs, pkgs, config, lib, hostVars, ... }:
{
  imports = [ inputs.niri.nixosModules.niri ];

  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [ nautilus ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  home-manager.users.${hostVars.username}.programs.niri.settings = lib.mkMerge [
    {
      binds = {
        "Mod+Return".action.spawn = "kitty";
        "Mod+Q".action.close-window = [];
        "Mod+Space".action.spawn = "wofi --show drun";

        "Mod+J".action.focus-column-left = [];
        "Mod+K".action.focus-window-or-workspace-down = [];
        "Mod+L".action.focus-window-or-workspace-up = [];
        "Mod+semicolon".action.focus-column-right = [];

        "Mod+Left".action.focus-column-left = [];
        "Mod+Down".action.focus-window-or-workspace-down = [];
        "Mod+Up".action.focus-window-or-workspace-up = [];
        "Mod+Right".action.focus-column-right = [];

        "Mod+Shift+J".action.move-column-left = [];
        "Mod+Shift+K".action.move-window-down = [];
        "Mod+Shift+L".action.move-window-up = [];
        "Mod+Shift+semicolon".action.move-column-right = [];

        "Mod+Shift+Left".action.move-column-left = [];
        "Mod+Shift+Down".action.move-window-down = [];
        "Mod+Shift+Up".action.move-window-up = [];
        "Mod+Shift+Right".action.move-column-right = [];

        "Mod+F".action.fullscreen-window = [];

        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;
        "Mod+0".action.focus-workspace = 10;

        "Mod+Shift+1".action.move-window-to-workspace = 1;
        "Mod+Shift+2".action.move-window-to-workspace = 2;
        "Mod+Shift+3".action.move-window-to-workspace = 3;
        "Mod+Shift+4".action.move-window-to-workspace = 4;
        "Mod+Shift+5".action.move-window-to-workspace = 5;
        "Mod+Shift+6".action.move-window-to-workspace = 6;
        "Mod+Shift+7".action.move-window-to-workspace = 7;
        "Mod+Shift+8".action.move-window-to-workspace = 8;
        "Mod+Shift+9".action.move-window-to-workspace = 9;
        "Mod+Shift+0".action.move-window-to-workspace = 10;

        "Mod+Shift+E".action.quit.skip-confirmation = true;

        "Mod+Shift+S".action.spawn = [
          "sh" "-c" "grim -g \"$(slurp)\" - | wl-copy -t image/png"
        ];

        "XF86AudioRaiseVolume".action.spawn = [
          "pactl" "set-sink-volume" "@DEFAULT_SINK@" "+10%"
        ];
        "XF86AudioLowerVolume".action.spawn = [
          "pactl" "set-sink-volume" "@DEFAULT_SINK@" "-10%"
        ];
        "XF86AudioMute".action.spawn = [
          "pactl" "set-sink-mute" "@DEFAULT_SINK@" "toggle"
        ];
        "XF86AudioMicMute".action.spawn = [
          "pactl" "set-source-mute" "@DEFAULT_SOURCE@" "toggle"
        ];
      };

      input.touchpad = {
        natural-scroll = true;
        tap = true;
      };

      layout.gaps = 5;

      spawn-at-startup = [
        { argv = [ "swaync" ]; }
      ];
    }

    (lib.mkIf (!(config ? stylix && config.stylix.enable)) {
      layout.border = {
        enable = true;
        active = { color = "#c4a7e7"; };
        inactive = { color = "#6e6a86"; };
      };
    })
  ];
}
