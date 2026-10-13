{ lib
, stdenvNoCC
, fetchurl
, unzip
, makeWrapper
, dpkg
, autoPatchelfHook
, wrapGAppsHook3
, gtk3
, webkitgtk_4_1
, glib
, gdk-pixbuf
, libsoup_3
}:
let
  version = "1.16.0";
  sources = {
    x86_64-linux = {
      asset = "linux_amd64.deb";
      hash = "sha256-0qeGyiV10edljzXneGej1kknfQvk8KBLAPSggIZPNfI=";
    };
    x86_64-darwin = {
      asset = "darwin_universal.zip";
      hash = "sha256-EjIJ16rIn2+7jL6Me1crN9NLe5LGv3u2k413/I+6uds=";
    };
    aarch64-darwin = {
      asset = "darwin_universal.zip";
      hash = "sha256-EjIJ16rIn2+7jL6Me1crN9NLe5LGv3u2k413/I+6uds=";
    };
  };
  source = sources.${stdenvNoCC.hostPlatform.system} or (throw "Unsupported Radar Desktop platform: ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation {
  pname = "radar-desktop-bin";
  inherit version;

  src = fetchurl {
    url = "https://github.com/skyhook-io/radar/releases/download/v${version}/radar-desktop_v${version}_${source.asset}";
    inherit (source) hash;
  };

  sourceRoot = ".";
  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;
  # Keep fixups from modifying the macOS bundle after signing it.
  dontFixup = stdenvNoCC.hostPlatform.isDarwin;

  nativeBuildInputs =
    if stdenvNoCC.hostPlatform.isDarwin
    then [ unzip makeWrapper ]
    else [ dpkg autoPatchelfHook wrapGAppsHook3 ];

  buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    gtk3
    webkitgtk_4_1
    glib
    gdk-pixbuf
    libsoup_3
  ];

  unpackPhase = lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
    runHook preUnpack
    dpkg-deb -x "$src" .
    runHook postUnpack
  '';

  installPhase =
    if stdenvNoCC.hostPlatform.isDarwin
    then ''
      runHook preInstall
      mkdir -p "$out/Applications" "$out/bin"
      cp -R Radar.app "$out/Applications/Radar.app"
      # The upstream universal archive has an invalid signature; sign locally.
      /usr/bin/codesign --force --sign - "$out/Applications/Radar.app"
      makeWrapper "$out/Applications/Radar.app/Contents/MacOS/Radar" "$out/bin/radar-desktop"
      runHook postInstall
    ''
    else ''
      runHook preInstall
      install -Dm755 usr/bin/radar-desktop "$out/bin/radar-desktop"
      mkdir -p "$out/share"
      cp -R usr/share/applications usr/share/icons "$out/share/"
      substituteInPlace "$out/share/applications/radar-desktop.desktop" \
        --replace-fail 'Exec=radar-desktop' "Exec=$out/bin/radar-desktop"
      runHook postInstall
    '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Native Kubernetes desktop dashboard with topology, events, Helm, GitOps, and MCP support";
    homepage = "https://github.com/skyhook-io/radar";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = builtins.attrNames sources;
    mainProgram = "radar-desktop";
  };
}
