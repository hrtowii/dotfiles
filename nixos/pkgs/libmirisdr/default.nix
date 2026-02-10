{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libusb1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmirisdr";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "f4exb";
    repo = "libmirisdr-4";
    rev = "v2.0.0";
    sha256 = "sha256-HH9FEBcZdHvl5mEPduaIojQtFEIZaA2c4qUcHd7EVvk";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libusb1
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib -DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];

  meta = {
    homepage = "https://github.com/f4exb/libmirisdr-4";
    description = "Userspace library for MiriSDR receivers";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
  };
})

