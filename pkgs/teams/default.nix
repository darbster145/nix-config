{ lib
, stdenv
, fetchurl
, xar
, cpio
, makeWrapper
, vim
}:

let
  pname = "teams";
  versions = {
    darwin = "1.6.00.4464";
  };
  hashes = {
    darwin = "sha256-/M8sgqCPI7pCQUfCdT6C5yok14FG0Q9uA143sKT5s=";
  };
  meta = with lib; {
    description = "Microsoft Teams";
    homepage = "https://teams.microsoft.com";
    downloadPage = "https://teams.microsoft.com/downloads";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ darbster145 ];
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
    mainProgram = "teams";
  };

  appName = "Teams.app";
in
stdenv.mkDerivation {
  inherit pname meta;
  version = versions.darwin;

  src = fetchurl {
    url = "https://statics.teams.cdn.office.net/production-osx/enterprise/webview2/lkg/MicrosoftTeams.pkg";
    hash = hashes.darwin;
  };

  nativeBuildInputs = [ xar cpio makeWrapper vim ];

  unpackPhase = ''
    # Extract the main .pkg file
    xar -xf $src
    cd MicrosoftTeams_app.pkg

    # Extract pbzx archive
    pbzx_payload="Payload"
    xz_output="Payload.xz"
    decompressed_output="Payload.cpio"

    # Convert pbzx to xz
    exec 3<"$pbzx_payload"
    header=$(dd bs=4 count=1 <&3 2>/dev/null)
    if [ "$header" != "pbzx" ]; then
      echo "Error: Not a pbzx file"
      exit 1
    fi

    > "$xz_output"
    while true; do
      size=$(dd bs=8 count=1 <&3 2>/dev/null | xxd -p | tr -d '\n')
      [ -z "$size" ] && break
      chunk_size=$((16#$size))
      dd bs="$chunk_size" count=1 <&3 >> "$xz_output" 2>/dev/null || break
    done

    # Decompress xz archive
    xz -d "$xz_output"

    # Extract cpio archive
    cpio -id < "$${xz_output%.xz}"
  '';

  sourceRoot = "Applications/Teams.app";
  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{Applications/${appName},bin}
    cp -R . $out/Applications/${appName}
    makeWrapper $out/Applications/${appName}/Contents/MacOS/Teams $out/bin/teams
    runHook postInstall
  '';
}

