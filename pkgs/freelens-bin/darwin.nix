{ stdenvNoCC
, pname
, version
, src
, meta
, undmg
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

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R "Freelens.app" "$out/Applications/Freelens.app"

    runHook postInstall
  '';

  dontFixup = true;
}

