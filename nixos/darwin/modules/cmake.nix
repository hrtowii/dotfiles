{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    automake
    cmake
    clang-tools # includes clang-format
    gnumake
    nasm
    ninja
    pkg-config
    ccache
    # owning the libs
    # libepoxy
    # llvmPackages.openmp
    # libtermkey
    # libusb-compat-0_1
    # libvterm
    # msgpack
    # zlib
  ];
}
