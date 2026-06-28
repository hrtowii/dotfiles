# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, hostVars, ... }:
let config_path = ../../home-manager/config/pipewire/pipewire.conf.d/teapro.txt;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./system-packages.nix
      ./system-modules
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_6_18;
  boot.supportedFilesystems = [ "ntfs" ];
  zramSwap.enable = true;
  swapDevices = [{
    device = "/swapfile";
    size = 16 * 1024; # 16GB
  }];
  networking.hostName = hostVars.hostname;
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.macAddress = "random";
  # Set your time zone.
  time.timeZone = "Asia/Singapore";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_SG.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_SG.UTF-8";
    LC_IDENTIFICATION = "en_SG.UTF-8";
    LC_MEASUREMENT = "en_SG.UTF-8";
    LC_MONETARY = "en_SG.UTF-8";
    LC_NAME = "en_SG.UTF-8";
    LC_NUMERIC = "en_SG.UTF-8";
    LC_PAPER = "en_SG.UTF-8";
    LC_TELEPHONE = "en_SG.UTF-8";
    LC_TIME = "en_SG.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;
  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };


  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  services.pipewire.extraConfig.pipewire."10-parametric-eq" = {
  context.modules = [
    {
      name = "libpipewire-module-parametric-equalizer";
      args = {
        remote.name = "pipewire-0";
        equalizer.filepath = config_path;
        equalizer.description = "Parametric EQ Sink";
        audio.channels = 2;
        audio.position = [ "FL" "FR" ];
        capture.props = {
          node.name = "Parametric EQ input";
        };
        playback.props = {
          node.name = "Parametric EQ output";
          target.object = "alsa_output.pci-0000_00_1f.3.analog-stereo";
        };
      };
    }
  ];
};
  services.sunshine = {
    enable = true;
    autoStart = true;
    openFirewall = true;
    capSysAdmin = true;
    package = pkgs.sunshine.override { boost = pkgs.boost187; };
  };

  users.users.${hostVars.username} = {
    isNormalUser = true;
    description = "saccade";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  #
  # Enable automatic login for the user.
  # services.displayManager.autoLogin.enable = true;
  # services.displayManager.autoLogin.user = "htrowii";
  nix.settings = {
    auto-optimise-store = true;
    max-jobs = 3;
    cores = 4;
    experimental-features = ["nix-command" "flakes"];
    substituters = [
      "https://cache.nixos.org"
      "https://nix-gaming.cachix.org"
      "https://anyrun.cachix.org"
      # "https://ghostty.cachix.org"
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
      "https://ezkea.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      # "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
    ];
  };
  hardware.graphics = {
    enable = true;
  };
  system.stateVersion = hostVars.stateVersion;

}
