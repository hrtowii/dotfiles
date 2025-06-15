 { config, pkgs, ... }:
{
    services.flatpak.enable = true;
    # roblox
    # flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    # flatpak install flathub org.vinegarhq.Sober
}
