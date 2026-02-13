{ config, pkgs, ... }:

let
  bat-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
  net-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
  audio-icons = ["󰝟" "󰕿" "󰖀" "󰕾"];
  generic-percent-icons = ["󰪞" "󰪜" "󰪚"];
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };
}
