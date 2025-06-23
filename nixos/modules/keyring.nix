{ pkgs, config, lib, ... }:
# https://nixos.wiki/wiki/GNOME#Running_GNOME_programs_outside_of_GNOME
# GNOME Keyring for storing/encrypting sycrets
# apps like vscode stores encrypted data using it
{
services.gnome.gnome-keyring.enable = true;
environment.systemPackages = [pkgs.libsecret];
# programs.seahorse.enable = true;
environment.variables.XDG_RUNTIME_DIR = "/run/user/$UID"; # this is what was missing
security.pam.services.sddm.enableGnomeKeyring = true; # ly or any other display manager (sddm/greetd/gdm...)
security.pam.services.sddm.enableKwallet = true;
}
