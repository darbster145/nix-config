{ inputs, config, ... }:

{
  nix-homebrew = {
    enable = true;
    #autoMigrate = true;
    enableRosetta = true;
    user = "brad";
    mutableTaps = false;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
    };
  };

}
