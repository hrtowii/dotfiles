{ config, pkgs, lib, ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      # Add more starship configuration here
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_status"
        "$nix_shell"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];
    };
  };
}
