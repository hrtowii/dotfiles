{ pkgs, config, lib, hostVars, ... }:
{
  config = {
    home-manager.users.${hostVars.username}.programs.kitty = {
      enable = true;
      settings = {
        cursor_shape = "block";
        remember_window_size = false;
        initial_window_width = 640;
        initial_window_height = 400;
        window_padding_width = 5;
        hide_window_decorations = "titlebar-only";
        confirm_os_window_close = 0;
        shell_integration = "no-cursor";
      };
    };
  };
}
