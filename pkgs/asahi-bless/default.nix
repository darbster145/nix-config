{ lib
, fetchCrate
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "asahi-bless";
  version = "0.4.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-s4h5AwYjneITd+8d3xolgduJB3JarMO6lyN8EWrruqI=";
  };

  cargoHash = "sha256-abMf/bo22mEvqgWpRRtsuDezeibcdooWurjtJc2XMFE=";
  cargoDepsName = pname;

  meta = with lib; {
    description = "Tool to select active boot partition on ARM Macs";
    homepage = "https://crates.io/crates/asahi-bless";
    license = licenses.mit;
    maintainers = with maintainers; [ lukaslihotzki ];
    mainProgram = "asahi-bless";
    platforms = platforms.linux;
  };
}
