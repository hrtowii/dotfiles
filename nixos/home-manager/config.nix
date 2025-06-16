let configDir = ./config;
in
{
  home.file = {
      ".config/btop".source = "${configDir}/btop";
      ".config/kitty".source="${configDir}/kitty";
      ".config/zellij".source = "${configDir}/zellij";
      ".config/ghostty".source="${configDir}/ghostty";
      ".config/spicetify".source="${configDir}/spicetify";
      ".config/nvim".source = "${configDir}/nvim";
      ".config/neofetch".source = "${configDir}/neofetch";
      # quickshell dots (broken)
      # ".config/hypr".source = "${configDir}/hypr";
      # ".config/quickshell/caelestia".source = "${configDir}/caelestia-shell";
      ".config/fastfetch".source = "${configDir}/fastfetch";
      ".config/uwsm".source = "${configDir}/uwsm";
      ".zshrc".source = "${configDir}/zsh/.zshrc";

      # https://github.com/gpskwlkr/nixos-hyprland-flake/blob/main/home/user/config.nix
      ".config/hypr".source = "${configDir}/unused/hypr";
      ".config/swayidle".source = "${configDir}/unused/swayidle";
      ".config/swaylock".source = "${configDir}/unused/swaylock";
      ".config/wlogout".source = "${configDir}/unused/wlogout";
      ".config/waybar".source = "${configDir}/unused/waybar";
      ".config/wofi".source = "${configDir}/unused/wofi";
      ".config/mako".source = "${configDir}/unused/mako";
      ".config/wallpapers".source = "${configDir}/unused/wallpapers";
  };
}
