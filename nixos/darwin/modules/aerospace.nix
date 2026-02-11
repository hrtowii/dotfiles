{ pkgs, config, ... }: {
  services.aerospace = {
    enable = true;
    package = pkgs.aerospace;
    # note: binds are stil using skhd because i need right alt
    # good reference: https://github.com/HestHub/nixos/blob/12c664a1800ebec80f38285f87847edf59bdb8e2/modules/darwin/apps.nix#L6
    
    settings = {
      exec-on-workspace-change = [
        "/bin/bash"
        "-c"
        "/etc/profiles/per-user/${config.system.primaryUser}/bin/sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=\"$AEROSPACE_FOCUSED_WORKSPACE\""
      ];
      
      on-focus-changed = [
        "exec-and-forget /etc/profiles/per-user/${config.system.primaryUser}/bin/sketchybar --trigger aerospace_window_change"
      ];
      
      gaps = {
        inner = {
          horizontal = 10;
          vertical = 10;
        };
        outer = {
          left = 10;
          bottom = 10;
          top = 10;
          right = 10;
        };
      };
    };
  };
}
