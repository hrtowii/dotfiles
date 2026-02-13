{ config, lib, pkgs, vars, ... }:

let configDir = ./config;
in
{
  home.file = {
      ".config/btop".source = "${configDir}/btop";
      ".config/kitty".source="${configDir}/kitty";
      ".config/zellij".source = "${configDir}/zellij";
      ".config/ghostty".source="${configDir}/ghostty";
      ".config/spicetify".source="${configDir}/spicetify";
      ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/home-manager/config/nvim";
      ".config/neofetch".source = "${configDir}/neofetch";
      ".config/fastfetch".source = "${configDir}/fastfetch";
      ".config/gqrx".source = "${configDir}/gqrx";
      ".config/uwsm".source = "${configDir}/uwsm";
      ".zshrc".source = "${configDir}/zsh/.zshrc";
      ".config/hypr".source = "${configDir}/hypr";
      ".config/wallpapers".source = "${configDir}/wallpapers";
      ".local/share/fonts".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/home-manager/fonts";
      ".config/pipewire/pipewire.conf.d".source = "${configDir}/pipewire/pipewire.conf.d";
      ".local/bin/toggle-refresh".source = ./scripts/toggle-refresh.sh;
      ".local/bin/toggle-refresh".executable = true;
  };
}
