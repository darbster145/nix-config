{ inputs, pkgs }:

let
  polaris = inputs.polaris.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  # Nix's builtin fetcher cannot resolve upstream's nested submodules
  # (Granite -> SPIRV-Tools), so fetch the source with git instead.
  # Update the hash whenever the polaris input is bumped.
  package =
    (polaris.polaris-stream.override {
      cudaSupport = false;
      # pcre was removed from nixpkgs; upstream still lists it.
      pcre = pkgs.pcre2;
      polarisSrc = pkgs.fetchgit {
        url = "https://github.com/papi-ux/polaris";
        rev = inputs.polaris.rev;
        fetchSubmodules = true;
        hash = "sha256-qGIN43Ubwpj60+b8IgcAnMaDa2ul6z+fC2scRfTZMtI=";
      };
    }).overrideAttrs
      (old: {
        # Upstream only adds vulkan-headers with CUDA, but cmake always needs them.
        buildInputs = old.buildInputs ++ [ pkgs.vulkan-headers ];
        # The Home Manager module builds a wrapped launcher with its runtime
        # dependencies. Keep that one, rather than the unwrapped copy shipped
        # in the Polaris package (which collides in home.packages).
        postInstall = (old.postInstall or "") + ''
          rm -f $out/bin/polaris-gamescope-session
        '';
      });
  packageGamescope = polaris.gamescope-polaris;
  packagePortal = polaris.xdg-desktop-portal-gamescope;
}
