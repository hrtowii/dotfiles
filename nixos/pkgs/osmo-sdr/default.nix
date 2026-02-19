{ pkgs ? import <nixpkgs> {} }:

let
  libosmocore-sq5bpf = pkgs.stdenv.mkDerivation rec {
    pname = "libosmocore-sq5bpf";
    version = "unstable-2024-01-01";  # Update this if needed
    
    src = pkgs.fetchFromGitHub {
      owner = "sq5bpf";
      repo = "libosmocore-sq5bpf";
      rev = "master";
      sha256 = "sha256-jbfzgdvBrlCqVqgbZab9CR9ANAyo33BiIi+qafAiKFQ=";  # Replace with actual hash
    };
    
    nativeBuildInputs = with pkgs; [
      autoreconfHook
      pkg-config
    ];
    
    buildInputs = with pkgs; [
      talloc
      pcsclite
      libusb1
    ];
    
    propagatedBuildInputs = with pkgs; [
      talloc
    ];
    
    configureFlags = [
      "--disable-pcsc"
      "--disable-usb"
    ];
    
    meta = with pkgs.lib; {
      description = "Custom libosmocore for osmo-tetra-sq5bpf";
      homepage = "https://github.com/sq5bpf/libosmocore-sq5bpf";
      license = licenses.gpl2;
      platforms = platforms.linux;
    };
  };

  # osmo-tetra-sq5bpf-2
  osmo-tetra-sq5bpf-2 = pkgs.stdenv.mkDerivation rec {
    pname = "osmo-tetra-sq5bpf-2";
    version = "unstable-2024-01-01";  # Update this if needed
    
    src = pkgs.fetchFromGitHub {
      owner = "sq5bpf";
      repo = "osmo-tetra-sq5bpf-2";
      rev = "master";  # Pin to specific commit for reproducibility
      sha256 = "sha256-1hUUmnnmSQU9MP5t2CqzSS6TlKiPLkGx9pB5cSieDcY=";  # Replace with actual hash
    };
    
    nativeBuildInputs = with pkgs; [
      autoreconfHook
      automake
      autoconf
      libtool
      pkg-config
    ];
    
    buildInputs = with pkgs; [
      libosmocore-sq5bpf
      talloc
    ];
    
    propagatedBuildInputs = [
      libosmocore-sq5bpf
    ];
    
    preConfigure = ''
      export PKG_CONFIG_PATH="${libosmocore-sq5bpf}/lib/pkgconfig:$PKG_CONFIG_PATH"
      export CFLAGS="-I${libosmocore-sq5bpf}/include $CFLAGS"
      export LDFLAGS="-L${libosmocore-sq5bpf}/lib $LDFLAGS"
    '';
    
    meta = with pkgs.lib; {
      description = "TETRA MAC/PHY layer experimentation code with telive-2 support";
      homepage = "https://github.com/sq5bpf/osmo-tetra-sq5bpf-2";
      license = licenses.gpl2;
      platforms = platforms.linux;
      maintainers = [];
    };
  };

in {
  inherit libosmocore-sq5bpf osmo-tetra-sq5bpf-2;
  
  osmo-tetra-suite = pkgs.buildEnv {
    name = "osmo-tetra-suite";
    paths = [ libosmocore-sq5bpf osmo-tetra-sq5bpf-2 ];
  };
}
