{ pkgs, ... }: {
  services.sketchybar = {
    enable = true;

    extraPackages = [
      pkgs.jq
      pkgs.aerospace
    ];
  };
}
