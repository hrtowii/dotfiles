{pkgs, config, ...}:
{
  services.skhd = {
    enable = true;
    skhdConfig = ''
      ralt - escape : pmset displaysleepnow
      ralt + shift - s : osascript -e 'tell application "System Events" to sleep'

      ralt - return : open -na /Applications/Ghostty.app
      ralt + shift - return : open -na /Applications/Helium.app
      ralt + ctrl - return : open -na /Applications/Visual\ Studio\ Code.app
      ralt - c : open -na /Applications/System\ Settings.app

      :: resize @ : aerospace config active_window_border_color 0xFFFF00FF   # just a visual cue

      # toggle resize mode
      resize < ralt - r ; default
      default < ralt - r ; resize

      # resize bindings (use AeroSpace "resize" command)
      resize < left  : aerospace resize width -50
      resize < down  : aerospace resize height +50
      resize < up    : aerospace resize height -50
      resize < right : aerospace resize width +50

      ralt - a     : aerospace focus west
      ralt - s     : aerospace focus south
      ralt - w     : aerospace focus north
      ralt - d     : aerospace focus east
      ralt - left  : aerospace focus west
      ralt - down  : aerospace focus south
      ralt - up    : aerospace focus north
      ralt - right : aerospace focus east

      ralt - tab          : aerospace workspace next || aerospace workspace first
      ralt + shift - tab  : aerospace workspace prev || aerospace workspace last
      ralt - x            : aerospace workspace recent
      ralt - 1            : aerospace workspace 1
      ralt - 2            : aerospace workspace 2
      ralt - 3            : aerospace workspace 3
      ralt - 4            : aerospace workspace 4
      ralt - 5            : aerospace workspace 5
      ralt - 6            : aerospace workspace 6
      ralt - 7            : aerospace workspace 7
      ralt - 8            : aerospace workspace 8
      ralt - 9            : aerospace workspace 9

      ralt + shift - a : aerospace move left
      ralt + shift - s : aerospace move down
      ralt + shift - w : aerospace move up
      ralt + shift - d : aerospace move right
      ralt + shift - left  : aerospace move left
      ralt + shift - down  : aerospace move down
      ralt + shift - up    : aerospace move up
      ralt + shift - right : aerospace move right

      ralt + shift - x : aerospace move-node-to-workspace recent
      ralt + shift - 1 : aerospace move-node-to-workspace 1
      ralt + shift - 2 : aerospace move-node-to-workspace 2
      ralt + shift - 3 : aerospace move-node-to-workspace 3
      ralt + shift - 4 : aerospace move-node-to-workspace 4
      ralt + shift - 5 : aerospace move-node-to-workspace 5
      ralt + shift - 6 : aerospace move-node-to-workspace 6
      ralt + shift - 7 : aerospace move-node-to-workspace 7
      ralt + shift - 8 : aerospace move-node-to-workspace 8
      ralt + shift - 9 : aerospace move-node-to-workspace 9

      ralt + ctrl - m : aerospace move-node-to-workspace last && aerospace workspace last
      ralt + ctrl - p : aerospace move-node-to-workspace prev && aerospace workspace prev
      ralt + ctrl - n : aerospace move-node-to-workspace next && aerospace workspace next
      ralt + ctrl - 1 : aerospace move-node-to-workspace 1 && aerospace workspace 1
      ralt + ctrl - 2 : aerospace move-node-to-workspace 2 && aerospace workspace 2
      ralt + ctrl - 3 : aerospace move-node-to-workspace 3 && aerospace workspace 3
      ralt + ctrl - 4 : aerospace move-node-to-workspace 4 && aerospace workspace 4

      ralt - e : aerospace balance-sizes

      ralt + shift - space : aerospace floating toggle

      ralt - f            : aerospace fullscreen
      ralt + shift - f    : aerospace zoom toggle

      ralt - v : aerospace join-with down    # (no direct equivalent)
      ralt - h : aerospace join-with right     # (no direct equivalent)
    '';
  };
}
