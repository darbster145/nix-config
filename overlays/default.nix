# This file defines overlays
{ inputs, ... }: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });

    # nixpkgs node_modules hash for opencode 2.2.5 is stale on darwin; remove once fixed upstream.
    # opencode-desktop inherits node_modules from opencode, so this fixes both.
    opencode =
      if prev.stdenv.hostPlatform.isDarwin && prev.opencode.version == "2.2.5" then
        prev.opencode.overrideAttrs (old: {
          node_modules = old.node_modules.overrideAttrs {
            outputHash = "sha256-dIveiaiPFGSItwLyeMuPDxTE9gpvvnlTCB/+nG24qCc=";
          };
        })
      else
        prev.opencode;
  };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };
}
