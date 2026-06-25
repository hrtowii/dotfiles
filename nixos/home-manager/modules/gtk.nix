# https://github.com/gpskwlkr/nixos-hyprland-flake/blob/main/home/user/gtk.nix
{ pkgs, ... }:
{
  gtk = {
    enable = true;

    # cursorTheme = {
    #   name = "Catppuccin-Mocha-Dark-Cursors";
    #   package = pkgs.catppuccin-cursors.mochaDark;
    # };
    #
    # theme = {
    #   name = "Catppuccin-Macchiato-Compact-Blue-dark";
    #   package = pkgs.catppuccin-gtk.override {
    #     size = "compact";
    #     accents = [ "pink" ];
    #     variant = "mocha";
    #   };
    # };
    # iconTheme = {
    #   name = "Papirus-Dark";
    #   package = pkgs.papirus-folders;
    # };
    #
    # gtk3.extraConfig = {
    #     Settings = ''
    #         gtk-application-prefer-dark-theme = 1;
    #     '';
    # };
    #
    # gtk4.extraConfig = {
    #     Settings = ''
    #         gtk-application-prefer-dark-theme = 1;
    #         '';
    # };

  };
}
