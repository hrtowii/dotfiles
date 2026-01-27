{ pkgs, ... }: {
  services.aerospace = {
    enable = true;
    package = pkgs.aerospace;
    
    settings = {
      # Sketchybar integration
      exec-on-workspace-change = [
        "/bin/bash"
        "-c"
        "sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=\"$AEROSPACE_FOCUSED_WORKSPACE\""
      ];
      
      on-focus-changed = [
        "exec-and-forget sketchybar --trigger aerospace_window_change"
      ];
      
      # Gaps configuration
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
