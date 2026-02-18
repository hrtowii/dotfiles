{ config, pkgs, lib, ... }:
{
nixpkgs.overlays = [
    ida-pro-overlay.overlays.default
];
environment.systemPackages = [
    ida-pro
];
}
