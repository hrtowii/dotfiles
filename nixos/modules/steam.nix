{pkgs, ...}: {
  programs.steam = {
    enable = true;
    # apparently enabling this makes big picture boot up, does not work on nvidia however
    # gamescopeSession.enable = true;
    extraCompatPackages = [
      pkgs.proton-ge-bin
    ];
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  environment.systemPackages = with pkgs; [
    lutris
    wineWowPackages.stable
    winetricks
    protontricks
    gamemode
    mangohud
    vulkan-tools
    vulkan-loader
    vulkan-headers
    vulkan-validation-layers
    libstrangle
    piper
    portaudio
    alsa-lib
    libglvnd
  ];
}
