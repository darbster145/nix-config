# Based on https://github.com/NixOS/nixpkgs/pull/585097; drop this once it lands in nixpkgs.
{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  jq,
  coreutils,
}:

let
  version = "0.1.5";
  # The Rust CLI is published as one native npm package per platform.
  targets = {
    x86_64-linux = {
      name = "linux-x64";
      hash = "sha512-4C5eUD1WkeozFRTsnSWRCzeMHbVs3FOp2QEI5+/yqJSFy00Sc+E7YvC01lSnEEmdWy85AMUCsrqqwNAFJTGa1A==";
    };
    aarch64-linux = {
      name = "linux-arm64";
      hash = "sha512-EEOo0Sk4jDtifLW40CHjMiGlRgOW/SSNXtqUnomppXUqIVGDmlXRzPkQrm/26t0lwZOUdSkxro0yAML80Tw9nA==";
    };
    x86_64-darwin = {
      name = "darwin-x64";
      hash = "sha512-ZjWAlCYzHdaMntuZeOZbKW9XEZ8sWxvpmeNzc5s5aTIEG6t2VNDmlHrER7oCg2Z+8kzLTOS29qkNhWNnsU+pbQ==";
    };
    aarch64-darwin = {
      name = "darwin-arm64";
      hash = "sha512-c3jdW5KyvTkfLPThVxowNaHydLd8asiUvb85sSvfSrLRaBpECFrpNO+OICUZnebsHc/hDX9rXZ2DahkYN5+dKA==";
    };
  };
  target =
    targets.${stdenv.hostPlatform.system}
      or (throw "Unsupported browse platform: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "opencode-browse";
  inherit version;
  strictDeps = true;

  src = fetchurl {
    url = "https://registry.npmjs.org/@opencode/browse-${target.name}/-/browse-${target.name}-${version}.tgz";
    inherit (target) hash;
  };

  sourceRoot = "package";
  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  nativeBuildInputs = [
    makeWrapper
    jq
    coreutils
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  passthru.updateScript = ./update.sh;

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/browse "$out/bin/browse"
    runHook postInstall
  '';

  # Nix owns updates; do not let the upstream updater replace this binary.
  postFixup = ''
    wrapProgram "$out/bin/browse" --set OPENCODE_BROWSER_AUTO_UPDATE off
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    export HOME="$TMPDIR/home"
    mkdir -p "$HOME"
    test "$("$out/bin/browse" --version)" = "${version}"
    status=0
    printf '%s\n' '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"nix","version":"1"}}}' \
      | timeout 15 "$out/bin/browse" mcp > "$TMPDIR/initialize.json" || status=$?
    test "$status" -eq 0 || test "$status" -eq 130
    jq -se 'any(.[]; .id == 1 and .result.serverInfo.name == "browse" and .result.serverInfo.version == "${version}")' \
      "$TMPDIR/initialize.json"
    runHook postInstallCheck
  '';

  meta = {
    description = "MCP server and CLI for automating a signed-in Chromium browser";
    homepage = "https://github.com/anomalyco/browse";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = builtins.attrNames targets;
    mainProgram = "browse";
  };
}
