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
      ".config/hypr".source = "${configDir}/hypr";
      ".config/.zshrc".source = "${configDir}/.zshrc";
  };
}
