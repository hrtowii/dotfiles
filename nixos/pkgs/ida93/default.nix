{
  pkgs,
  lib,
  extraFiles ? "",
  ...
}:
let
  pythonForIDA = pkgs.python313.withPackages (ps: with ps; [ rpyc ]);
  
  idaKeygen = pkgs.writeText "ida-keygen.py" ''
    import hashlib
    import json
    from pathlib import Path
    import sys

    if len(sys.argv) != 2:
        print("Usage: ida-keygen.py <ida_install_path>")
        sys.exit(1)

    LOCATION = Path(sys.argv[1])
    VERSION = "9.3.0.260213"  # Match package version
    
    NAME = "NixOS User"
    EMAIL = "nixos@localhost"
    ID_PREFIX = "48-3FBD-7F04"

    license = {
        "header": {"version": 1},
        "payload": {
            "name": NAME,
            "email": EMAIL,
            "licenses": [
                {
                    "description": "license",
                    "edition_id": "ida-pro",
                    "id": f"{ID_PREFIX}-00",
                    "license_type": "named",
                    "product": "IDA",
                    "seats": 1,
                    "start_date": "2024-08-10 00:00:00",
                    "end_date": "2033-12-31 23:59:59",
                    "issued_on": "2024-08-10 00:00:00",
                    "owner": NAME,
                    "product_id": "IDAPRO",
                    "add_ons": [],
                    "features": [],
                }
            ],
        },
    }

    def add_every_addon(license):
        addons = [
            "HEXX86", "HEXX64", "HEXARM", "HEXARM64",
            "HEXMIPS", "HEXMIPS64", "HEXPPC", "HEXPPC64",
            "HEXRV64", "HEXARC", "HEXARC64",
        ]
        for i, addon in enumerate(addons, start=1):
            license["payload"]["licenses"][0]["add_ons"].append({
                "id": f"{ID_PREFIX}-{i:02}",
                "code": addon,
                "owner": license["payload"]["licenses"][0]["id"],
                "start_date": "2024-08-10 00:00:00",
                "end_date": "2033-12-31 23:59:59",
            })

    add_every_addon(license)

    def json_stringify_alphabetical(obj):
        return json.dumps(obj, sort_keys=True, separators=(",", ":"))

    def buf_to_bigint(buf):
        return int.from_bytes(buf, byteorder="little")

    def bigint_to_buf(i):
        return i.to_bytes((i.bit_length() + 7) // 8, byteorder="little")

    pub_modulus_patched = buf_to_bigint(bytes.fromhex(
        "edfd42cbf978546e8911225884436c57140525650bcf6ebfe80edbc5fb1de68f4c66c29cb22eb668788afcb0abbb718044584b810f8970cddf227385f75d5dddd91d4f18937a08aa83b28c49d12dc92e7505bb38809e91bd0fbd2f2e6ab1d2e33c0c55d5bddd478ee8bf845fcef3c82b9d2929ecb71f4d1b3db96e3a8e7aaf93"
    ))

    private_key = buf_to_bigint(bytes.fromhex(
        "77c86abbb7f3bb134436797b68ff47beb1a5457816608dbfb72641814dd464dd640d711d5732d3017a1c4e63d835822f00a4eab619a2c4791cf33f9f57f9c2ae4d9eed9981e79ac9b8f8a411f68f25b9f0c05d04d11e22a3a0d8d4672b56a61f1532282ff4e4e74759e832b70e98b9d102d07e9fb9ba8d15810b144970029874"
    ))

    def encrypt(message):
        encrypted = pow(buf_to_bigint(message[::-1]), private_key, pub_modulus_patched)
        encrypted = bigint_to_buf(encrypted)
        return encrypted

    def sign_hexlic(payload):
        data = {"payload": payload}
        data_str = json_stringify_alphabetical(data)
        buffer = bytearray(128)
        for i in range(33):
            buffer[i] = 0x42
        sha256 = hashlib.sha256()
        sha256.update(data_str.encode())
        digest = sha256.digest()
        for i in range(32):
            buffer[33 + i] = digest[i]
        encrypted = encrypt(buffer)
        return encrypted.hex().upper()

    def patch_libida(filename_path):
        filename = filename_path.name
        if not filename_path.exists():
            print(f"Didn't find {filename}, skipping")
            return
        data = filename_path.read_bytes()
        if data.find(bytes.fromhex("EDFD42CBF978")) != -1:
            print(f"{filename} already patched")
            return
        if data.find(bytes.fromhex("EDFD425CF978")) == -1:
            print(f"{filename} doesn't contain original modulus")
            return
        data = data.replace(bytes.fromhex("EDFD425CF978"), bytes.fromhex("EDFD42CBF978"))
        filename_path.write_bytes(data)
        print(f"Patched {filename}")

    license["signature"] = sign_hexlic(license["payload"])
    serialized = json_stringify_alphabetical(license)
    
    license_path = LOCATION / "idapro.hexlic"
    license_path.write_text(serialized, encoding="utf-8")
    print(f"Saved license to {license_path}")

    for lib in ["libida.so", "libida32.so", "libida64.so"]:
        patch_libida(LOCATION / lib)

    print("Keygen complete!")
  '';
in
pkgs.stdenv.mkDerivation rec {
  pname = "ida-pro";
  version = "9.3.260213";

  src = pkgs.requireFile {
    name = "ida-pro_93_x64linux.run";
    url = "https://my.hex-rays.com/";
    sha256 = "sha256-LtQ65LuE103K5vAJkhDfqNYb/qSVL1+aB6mq4Wy3D4I=";
  };

  desktopItem = pkgs.makeDesktopItem {
    name = "ida-pro";
    exec = "ida";
    icon = ./appico.png;
    comment = meta.description;
    desktopName = "IDA Pro";
    genericName = "Interactive Disassembler";
    categories = [ "Development" ];
    startupWMClass = "IDA";
  };
  desktopItems = [ desktopItem ];

  nativeBuildInputs = with pkgs; [
    makeWrapper
    copyDesktopItems
    autoPatchelfHook
    qt6.wrapQtAppsHook
    python3
  ];

  dontUnpack = true;

  runtimeDependencies = with pkgs; [
    cairo
    dbus
    fontconfig
    freetype
    glib
    gtk3
    libdrm
    libGL
    libkrb5
    libsecret
    qt6.qtbase
    qt6.qtwayland
    libunwind
    libxkbcommon
    libsecret
    openssl.out
    stdenv.cc.cc
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libXau
    xorg.libxcb
    xorg.libXext
    xorg.libXi
    xorg.libXrender
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    xorg.xcbutilwm
    zlib
    curl.out
    pythonForIDA
  ];
  buildInputs = runtimeDependencies;

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall

    function print_debug_info() {
      if [ -f installbuilder_installer.log ]; then
        cat installbuilder_installer.log
      else
        echo "No debug information available."
      fi
    }

    trap print_debug_info EXIT

    mkdir -p $out/bin $out/lib $out/opt/.local/share/applications

    IDADIR="$out/opt"
    HOME="$out/opt"

    $(cat $NIX_CC/nix-support/dynamic-linker) $src \
      --mode unattended --debuglevel 4 --prefix $IDADIR

    for lib in $IDADIR/*.so $IDADIR/*.so.6; do
      ln -s $lib $out/lib/$(basename $lib)
    done

    patchelf --add-needed libpython3.13.so $out/lib/libida.so
    patchelf --add-needed libcrypto.so $out/lib/libida.so
    patchelf --add-needed libsecret-1.so.0 $out/lib/libida.so

    addAutoPatchelfSearchPath $IDADIR

    echo "Running auto-crack keygen..."
    python3 ${idaKeygen} $IDADIR

    for bb in ida; do
      wrapProgram $IDADIR/$bb \
        --prefix IDADIR : $IDADIR \
        --prefix QT_PLUGIN_PATH : $IDADIR/plugins/platforms \
        --prefix PYTHONPATH : $out/bin/idalib/python \
        --prefix PATH : ${pythonForIDA}/bin:$IDADIR \
        --prefix LD_LIBRARY_PATH : $out/lib
      ln -s $IDADIR/$bb $out/bin/$bb
    done

    if [ -n "${extraFiles}" ]; then
      cp -r "${extraFiles}"/* $out/opt/
    fi

    runHook postInstall
  '';

  meta = with lib; {
    description = "The world's smartest and most feature-full disassembler";
    homepage = "https://hex-rays.com/ida-pro/";
    license = licenses.unfree;
    mainProgram = "ida";
    maintainers = with maintainers; [ msanft ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
