{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.colima;
in
{
  home.packages = with pkgs; [
    docker
  ];

  services.colima = {
    enable = true;
    profiles.default = {
      isActive = true;
      isService = true;
      setDockerHost = true;
      settings = {
        cpu = 8;
        memory = 12;
        disk = 100;
        arch = "aarch64";
        runtime = "docker";
        vmType = "vz";
        mountType = "virtiofs";
        rosetta = true;
        kubernetes.enabled = false;
      };
    };
  };

  # The upstream agent PATH only contains Nix packages; Colima needs macOS
  # system tools (pkgutil, arch) to detect Rosetta.
  launchd.agents.colima-default.config.EnvironmentVariables.PATH = lib.mkForce (
    lib.concatStringsSep ":" [
      (lib.makeBinPath [
        cfg.package
        cfg.perlPackage
        cfg.dockerPackage
        cfg.sshPackage
        cfg.coreutilsPackage
        cfg.curlPackage
        cfg.bashPackage
        cfg.kubectlPackage
        pkgs.darwin.DarwinTools
      ])
      "/usr/bin:/bin:/usr/sbin:/sbin"
    ]
  );
}
