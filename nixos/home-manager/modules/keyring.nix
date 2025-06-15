{pkgs, ...}: {
services.gnome.gnome-keyring.enable = true;
environment.systemPackages = [pkgs.libsecret]; # google-chrome works with gnome-keyring through this
environment.variables.XDG_RUNTIME_DIR = "/run/user/$UID"; # this is what was missing
security.pam.services.ly.enableGnomeKeyring = true; # ly or any other display manager (sddm/greetd/gdm...)
}