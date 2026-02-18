{ config, pkgs, lib, inputs, ... }:
{
environment.systemPackages = [
    pkgs.ida-pro
];
}
