{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
    # These could also go into programs.neovim.extraPackages.
    # When i am developing and notice I am missing something I usually just launch myself into a nix shell or i add it here.
    home.packages = with pkgs; [
      # clang-tools
      # fd
      # gcc
      # git
      # go
      # lazygit
      # # nodejs
      # ripgrep
      # unzip
      # zig
    ];

    programs.neovim = {
      enable = true;
      vimAlias = true;
      vimdiffAlias = true;
      defaultEditor = true;
    };
}
