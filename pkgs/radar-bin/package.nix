{
  lib,
  stdenvNoCC,
  fetchurl,
}:
let
  version = "1.16.0";
  sources = {
    x86_64-linux = {
      platform = "linux_amd64";
      hash = "sha256-9sivhDQRfrp2oVU5NakQfc2lunz+u2PtH721cRgEeYw=";
    };
    aarch64-linux = {
      platform = "linux_arm64";
      hash = "sha256-vY3Azuzj3/h9LDqYGwRp5DEbjF2UKhp8zHmE1I55Vow=";
    };
    x86_64-darwin = {
      platform = "darwin_amd64";
      hash = "sha256-/QJPDTKi7tMTpKzNIBZyaPjgKmXA2voJgjpyO9W8nt8=";
    };
    aarch64-darwin = {
      platform = "darwin_arm64";
      hash = "sha256-peJsfBuSkb+u3JBKdsPYw19QD77tXgVmnvBJd3E8B+w=";
    };
  };
  source =
    sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported Radar platform: ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation {
  pname = "radar-bin";
  inherit version;

  src = fetchurl {
    url = "https://github.com/skyhook-io/radar/releases/download/v${version}/radar_v${version}_${source.platform}.tar.gz";
    inherit (source) hash;
  };

  sourceRoot = ".";
  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  passthru.updateScript = ./update.sh;

  installPhase = ''
    runHook preInstall
    install -Dm755 kubectl-radar "$out/bin/kubectl-radar"
    ln -s kubectl-radar "$out/bin/radar"
    install -Dm644 LICENSE "$out/share/licenses/radar-bin/LICENSE"
    runHook postInstall
  '';

  meta = {
    description = "Kubernetes dashboard with topology, events, Helm, GitOps, and MCP support";
    homepage = "https://github.com/skyhook-io/radar";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = builtins.attrNames sources;
    mainProgram = "radar";
  };
}
