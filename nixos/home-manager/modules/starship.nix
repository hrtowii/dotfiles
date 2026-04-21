{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.starship = {
    enable = true;

    settings = {
      add_newline = true;

      format = "[](fg:#907aa9)$username[](fg:#907aa9 bg:#d7827e)$directory[](fg:#d7827e bg:#ea9d34)[](fg:#ea9d34 bg:#56949f)[](fg:#56949f bg:#286983)[](fg:#286983 bg:#575279)$time[](fg:#575279) ";

      username = {
        show_always = true;
        style_user = "bg:#907aa9 fg:#faf4ed";
        style_root = "bg:#907aa9 fg:#faf4ed";
        format = "[$user ]($style)";
      };

      directory = {
        style = "bg:#d7827e fg:#575279";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";

        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
        };
      };

      git_branch = {
        symbol = "";
        style = "bg:#ea9d34 fg:#575279";
        format = "[$symbol $branch ]($style)";
      };

      git_status = {
        style = "bg:#ea9d34 fg:#575279";
        format = "[$all_status$ahead_behind]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:#56949f fg:#faf4ed";
        format = "[$symbol]($style)";
      };

      c = {
        symbol = " ";
        style = "bg:#56949f fg:#faf4ed";
        format = "[$symbol]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:#56949f fg:#faf4ed";
        format = "[$symbol]($style)";
      };

      golang = {
        symbol = " ";
        style = "bg:#56949f fg:#faf4ed";
        format = "[ $symbol ($version) ]($style)";
      };

      docker_context = {
        symbol = " ";
        style = "bg:#286983 fg:#faf4ed";
        format = "[$symbol]($style)";
      };

      time = {
        disabled = true;
        time_format = "%R";
        style = "bg:#575279 fg:#faf4ed";
        format = "[ ♥ $time ]($style)";
      };
    };
  };
}
