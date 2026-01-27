{ pkgs, ... }: {
  services.aerospace = {
    enable = true;
    package = pkgs.aerospace;
  };
}
