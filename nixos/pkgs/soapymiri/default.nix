{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  soapysdr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soapymiri";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "ericek111";
    repo = "SoapyMiri";
    rev = "d94629b58f70ae36a1b4e1f58277918cec600740;
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    soapysdr
  ];

  cmakeFlags = [
    "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR"
  ];

  meta = {
    homepage = "https://github.com/ericek111/SoapyMiri";
    description = "SoapySDR plugin for the Miri SDR";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})

