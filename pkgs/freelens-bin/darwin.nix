{ stdenvNoCC
, pname
, version
, src
, meta
, _7zz
,
}:

stdenvNoCC.mkDerivation {
  inherit
    pname
    version
    src
    meta
    ;

  sourceRoot = ".";

  nativeBuildInputs = [ _7zz ];

  unpackPhase = ''
    7zz x -snld $src
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/Applications"

    app_path="$(find . -maxdepth 5 -name '*.app' -type d | head -n 1)"
    test -n "$app_path" || (echo "No .app found"; find . -maxdepth 5 -print; exit 1)

    cp -R "$app_path" "$out/Applications/Freelens.app"

    runHook postInstall
  '';

  dontFixup = true;
}
