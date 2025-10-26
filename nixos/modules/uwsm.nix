{ pkgs, ... }:
{
  programs.uwsm = {
    enable = true;
    waylandCompositors.hyprland = {
      prettyName = "Hyprland";
      comment = "Hyprland compositor managed by UWSM";
      binPath = "${pkgs.writeShellScript "hyprland-wrapper" ''
        #!${pkgs.bash}/bin/bash
        export LD_LIBRARY_PATH=""
        exec ${pkgs.hyprland}/bin/Hyprland "$@"
      ''}";
    };
  };
}
