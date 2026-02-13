{ config, lib, pkgs, ... }:

let configDir = ./config;
in
{
  home.file = {
      # ".config/aerospace".source = "${configDir}/aerospace";
      ".config/btop".source = "${configDir}/btop";
      ".config/ghostty".source = "${configDir}/ghostty";
      ".config/helix".source = "${configDir}/helix";
      ".config/kitty".source = "${configDir}/kitty";
      ".config/ncspot".source = "${configDir}/ncspot";
      ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/dotfiles/nixos/darwin-home/config/nvim";
      ".config/sketchybar".source = "${configDir}/sketchybar";
      ".config/skhd".source = "${configDir}/skhd";
      ".config/spicetify".source = "${configDir}/spicetify";
      ".config/spotify-player".source = "${configDir}/spotify-player";
      ".config/wezterm".source = "${configDir}/wezterm";
      ".config/yabai".source = "${configDir}/yabai";
      ".config/zellij".source = "${configDir}/zellij";
  };
}
