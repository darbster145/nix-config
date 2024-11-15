{ lib
, fetchCrate
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "asahi-nvram";
  version = "0.2.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-QHfzgPqacEiZsVPtecN9vRY/H2G48eCJ24vCMcs1gKw=";
  };

  cargoHash = "sha256-KKdD+vC9M5slaH8yCDA5k52iLaIsQz2uCSrnrDG0IcQ=";
  cargoDepsName = pname;

  meta = with lib; {
    description = "Tool to read and write nvram variables on ARM Macs";
    homepage = "https://crates.io/crates/asahi-nvram";
    license = licenses.mit;
    maintainers = with maintainers; [ lukaslihotzki ];
    mainProgram = "asahi-nvram";
    platforms = platforms.linux;
  };
}

