{ config, ... }:

let
  configDir = ../../config;
in
{
  home.file = {
    ".config/btop".source = "${configDir}/btop";
    ".config/kitty".source = "${configDir}/kitty";
    ".config/zellij".source = "${configDir}/zellij";
    ".config/ghostty".source = "${configDir}/ghostty";
    ".config/spicetify".source = "${configDir}/spicetify";
    ".config/nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/home-manager/config/nvim-light";
    ".config/neofetch".source = "${configDir}/neofetch";
    ".config/fastfetch".source = "${configDir}/fastfetch";
    ".config/gqrx".source = "${configDir}/gqrx";
    ".config/uwsm".source = "${configDir}/uwsm";
    ".zshrc".source = "${configDir}/zsh/.zshrc";
    ".config/hypr".source = "${configDir}/hypr";
    ".config/sway/config".source = "${configDir}/i3/config";
    ".config/wofi".source = "${configDir}/wofi";
    ".config/waybar".source = "${configDir}/waybar";
    ".config/swaync/theme".source = "${configDir}/swaync/theme";
    ".config/wallpapers".source = "${configDir}/wallpapers";
    ".local/share/fonts".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/home-manager/fonts";
    ".config/pipewire/pipewire.conf.d".source = "${configDir}/pipewire/pipewire.conf.d";
    ".local/bin/toggle-refresh".source = ../../scripts/toggle-refresh.sh;
    ".local/bin/toggle-refresh".executable = true;
    ".config/fontconfig/fonts.conf".source = "${configDir}/fontconfig/fonts.conf";
    ".cargo/config.toml".source = "${configDir}/.cargo/config.toml";
  };
}
