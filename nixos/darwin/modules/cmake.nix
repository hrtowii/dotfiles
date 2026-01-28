{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    # Build Tools & Compilers
    automake
    cmake
    clang-tools # includes clang-format
    gnumake
    nasm
    ninja
    pkg-config
    ccache
    
    # Libraries
    libepoxy
    libomp
    libtermkey
    libusb-compat-0_1
    libvterm
    msgpack
    zlib
  ];
}
