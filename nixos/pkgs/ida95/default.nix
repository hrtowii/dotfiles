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

    NAME = "auth"
    EMAIL = "admin@hex-rays.com"
    LICENSE_ID = "14-0000-FFFF-88"

    license = {
        "header": {"version": 1},
        "payload": {
            "name": NAME,
            "email": EMAIL,
            "licenses": [
                {
                    "description": "license",
                    "edition_id": "ida-pro",
                    "id": LICENSE_ID,
                    "license_type": "named",
                    "product": "IDA",
                    "seats": 1,
                    "start_date": "2024-08-10 00:00:00",
                    "end_date": "2033-12-31 23:59:59",
                    "issued_on": "2025-07-20 00:00:00",
                    "owner": NAME,
                    "product_id": "IDAPRO",
                    "product_version": "9.5",
                    "add_ons": [],
                    "features": [],
                }
            ],
        },
    }

    def add_every_addon(license):
        addons = [
            "LUMINA", "TEAMS",
            "HEXX86", "HEXX64", "HEXARM", "HEXARM64",
            "HEXMIPS", "HEXMIPS64", "HEXPPC", "HEXPPC64",
            "HEXRV", "HEXRV64", "HEXARC", "HEXARC64",
            "HEXV850", "HEXDALVIK", "HEXTRICORE", "HEXQDSP6",
            "MALWARE",
        ]
        for i, addon in enumerate(addons, start=1):
            license["payload"]["licenses"][0]["add_ons"].append({
                "id": f"48-1337-B00B-{i:02}",
                "code": addon,
                "owner": license["payload"]["licenses"][0]["id"],
                "start_date": "2025-07-20 00:00:00",
                "end_date": "2033-12-31 23:59:59",
            })

    add_every_addon(license)

    def json_stringify_alphabetical(obj):
        return json.dumps(obj, sort_keys=True, separators=(",", ":"))

    def buf_to_bigint(buf):
        return int.from_bytes(buf, byteorder="little")

    pub_modulus_patched = buf_to_bigint(bytes.fromhex(
        "3f0307607fed562fd5a163adc40fcc603373caa28414e64cdc4552a555b13ad4b3ad0a812800a03195300fd71634b90edb0d69ea710efebb2b0b9e72da2effb149de70bcbfa94b86af01ce455dbbd5fa987207651c7b60c2e4cafd0654188d98c30f64dc084d8547f0ac32db91124af82b3b15bf922a31f1d5e332f27615cea7"
    ))

    private_key = buf_to_bigint(bytes.fromhex(
        "8b3f5fdfad7f87239734c530e2ecebeb4fa48d79518756c15fd54636801cf7ea6367100566bf8b52b16bec05258d8426ea94c15841ab2d37802c07349df4c208584e86d25a6bfb82966cb2ddcd3d654e9994e814ca470577362a937cc984e404a0b68d173aab3180130118e1b03ed209a9d8757560a85a3c9b0d3380e7907c4f"
    ))

    V54 = 127
    V56 = 95
    padkey = bytes.fromhex(
        "e2a7c300dfcc777f89b57500d8151c7fb1d97b3f9f170393311234ceeb9e377ae2a7c300dfcc777f89b57500d8151c7fb1d97b3f9f170393311234ceeb9e377ae2a7c300dfcc777f89b57500d8151c7fb1d97b3f9f170393311234ceeb9e377ae2a7c300dfcc777f89b57500d8151c7fb1d97b3f9f170393311234ceeb9e37"
    )

    def encrypt(message):
        encrypted = pow(buf_to_bigint(message[::-1]), private_key, pub_modulus_patched)
        out = bytearray()
        while encrypted > 0:
            out.append(encrypted & 0xFF)
            encrypted >>= 8
        return bytes(out)

    def sign_hexlic(payload):
        data_str = json_stringify_alphabetical({"payload": payload})
        digest = hashlib.sha256(data_str.encode()).digest()
        u = bytearray(V54)
        u[V56:V56 + 32] = digest
        block = bytearray(b ^ p for b, p in zip(u, padkey))
        if block[0] == 0:
            block[0] ^= 1
        encrypted = encrypt(bytes(block))
        out = bytearray(128)
        out[:len(encrypted)] = encrypted
        return out.hex().upper()

    SEARCH = bytes.fromhex(
        "29f4481f796f9f66f2ff13cc4ab5b54f60845db603ba2c0bac8a9bc4b6cbdefc5c62bfc2f5ee850ac45ea97ad347e8b56dba5085af8c8aad9cc2ec626ca78a068006d658f68651da31a0a77c65a70ed73a40d53b08edd403c095aa0bcffa52f313ebcacaaa2ce5024a4e2b9aa70fc6092f38ae094d71e43f7690b5ddd3e9e4f7"
    )
    REPLACE = bytes.fromhex(
        "a107b71c8a08ba5350934f7cf6e81be3a24dc2e35f7200d80cbd70b37ed6811dd2146d3cb7e20ad19b2544c0ef14c5c66ffbbdf226ec3f3d544c04385303ca4a7179299340022f5d50948bcf8a60307e2c196329e51a5296dc419e40fef3ef7c6f015a09ebd979e79615338985643e666c14897f9f597e11f44341f496d56861"
    )

    def patch_libida(filename_path):
        filename = filename_path.name
        if not filename_path.exists():
            print(f"Didn't find {filename}, skipping")
            return
        data = filename_path.read_bytes()
        if REPLACE in data:
            print(f"{filename} already patched")
            return
        count = data.count(SEARCH)
        if count == 0:
            print(f"{filename} doesn't contain original pattern")
            return
        data = data.replace(SEARCH, REPLACE)
        filename_path.write_bytes(data)
        print(f"Patched {filename} ({count} occurrence(s))")

    license["signature"] = sign_hexlic(license["payload"])
    serialized = json_stringify_alphabetical(license)

    license_path = LOCATION / "idapro.hexlic"
    license_path.write_text(serialized, encoding="utf-8")
    print(f"Saved license to {license_path}")

    for lib in ["libida.so", "libida32.so"]:
        patch_libida(LOCATION / lib)

    print("Keygen complete!")
  '';
in
pkgs.stdenv.mkDerivation rec {
  pname = "ida-pro";
  version = "9.5.261026";

  src = pkgs.requireFile {
    name = "ida-pro_95_x64linux.run";
    url = "https://my.hex-rays.com/";
    sha256 = "sha256-+LvHkEq3qxuGS7qmmDdDltUq+s08OUA9tt/y0M81UHU=";
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
    libice
    libsm
    libx11
    libxau
    libxcb
    libxext
    libxi
    libxrender
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    libxcb-wm
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
        --set QT_PLUGIN_PATH $IDADIR/plugins \
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
