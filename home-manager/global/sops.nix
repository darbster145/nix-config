{
  inputs,
  config,
  pkgs,
  ...
}:

let
  ageKeyFile = "${config.xdg.configHome}/sops/age/keys.txt";
in
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    age.keyFile = ageKeyFile;
    defaultSopsFile = ../../secrets/secrets.yaml;
  };

  home.sessionVariables.SOPS_AGE_KEY_FILE = ageKeyFile;

  home.packages = with pkgs; [
    sops
    age
  ];
}
