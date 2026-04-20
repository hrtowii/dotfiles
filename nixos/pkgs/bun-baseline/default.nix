{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  unzip,
  installShellFiles,
  makeWrapper,
  openssl,
}:
stdenvNoCC.mkDerivation rec {
  pname = "bun-baseline";
  version = "1.3.13";
  src = fetchurl {
    url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64-baseline.zip";
    hash = "sha256-nYokKSpwaAkCBdqsCloiP19pc29Sh+N7+I07QDHtx1A=";
  };
  sourceRoot = "bun-linux-x64-baseline";
  strictDeps = true;
  nativeBuildInputs = [
    unzip
    installShellFiles
    makeWrapper
    autoPatchelfHook
  ];
  buildInputs = [ openssl ];
  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;
  installPhase = ''
    runHook preInstall
    install -Dm 755 ./bun $out/bin/bun
    ln -s $out/bin/bun $out/bin/bunx
    runHook postInstall
  '';
  postFixup = ''
    autoPatchelf $out/bin/bun
  '';
  meta = {
    homepage = "https://bun.sh";
    changelog = "https://bun.sh/blog/bun-v${version}";
    description = "Bun JS runtime (baseline build, no AVX2 required)";
    mainProgram = "bun";
    platforms = [ "x86_64-linux" ];
  };
}
