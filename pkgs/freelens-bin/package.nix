{
  stdenv,
  stdenvNoCC,
  fetchurl,
  lib,
  appimageTools,
  makeWrapper,
  undmg,
}: let
  pname = "freelens-bin";
  version = "1.10.3";

  sources = {
    x86_64-linux = {
      url = "https://github.com/freelensapp/freelens/releases/download/v${version}/Freelens-${version}-linux-amd64.AppImage";
      hash = "sha256-W+RokOsT4WdVm4Yrmm8kbu7ApydhwLPpGmRjKTI1gek=";
    };
    aarch64-linux = {
      url = "https://github.com/freelensapp/freelens/releases/download/v${version}/Freelens-${version}-linux-arm64.AppImage";
      hash = "sha256-2aAw90YfTPDkiehj1ziurBeILEuEOmbJeUV2d7Bbmo4=";
    };
    x86_64-darwin = {
      url = "https://github.com/freelensapp/freelens/releases/download/v${version}/Freelens-${version}-macos-amd64.dmg";
      hash = "sha256-2bRiEUuVh8qNqvHOYlKd59PsZeQvOWKO38EOy9acMXU=";
    };
    aarch64-darwin = {
      url = "https://github.com/freelensapp/freelens/releases/download/v${version}/Freelens-${version}-macos-arm64.dmg";
      hash = "sha256-rjPhHV24WNofZK4sT3yjg1eGeAvLKvAuVf51bwiQBBk=";
    };
  };

  src = fetchurl {
    inherit (sources.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}")) url hash;
  };

  meta = {
    description = "Free IDE for Kubernetes";
    longDescription = ''
      Freelens is a free and open-source user interface designed for managing Kubernetes clusters. It provides a standalone application compatible with macOS, Windows, and Linux operating systems, making it accessible to a wide range of users. The application aims to simplify the complexities of Kubernetes management by offering an intuitive and user-friendly interface.
    '';
    homepage = "https://github.com/freelensapp/freelens/";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
    maintainers = with lib.maintainers; [skwig];
    platforms = builtins.attrNames sources;
    mainProgram = "freelens";
  };

  package =
    if stdenv.hostPlatform.isDarwin
    then
      import ./darwin.nix
      {
        inherit
          stdenvNoCC
          pname
          version
          src
          meta
          undmg
          ;
      }
    else
      import ./linux.nix {
        inherit
          pname
          version
          src
          meta
          appimageTools
          makeWrapper
          ;
      };
in
  package.overrideAttrs (old: {
    passthru =
      (old.passthru or {})
      // {
        updateScript = ./update.sh;
      };
  })
