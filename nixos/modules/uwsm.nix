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
    waylandCompositors.sway = {
    	prettyName = "Sway-nvidia";
	comment = "sway with --unsupported-gpu";
      binPath = "${pkgs.writeShellScript "sway-wrapper" ''
        #!${pkgs.bash}/bin/bash
        exec /run/current-system/sw/bin/sway "--unsupported-gpu"
	''}";
    };
  };
}
