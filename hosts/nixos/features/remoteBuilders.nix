{
  nix.buildMachines = [
    {
      hostName = "10.0.0.11";
      sshUser = "brad";
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      maxJobs = 1;
      speedFactor = 1;
      supportedFeatures = [ ];
    }
  ];

  nix.distributedBuilds = true;
  nix.settings.trusted-users = [ "root" "brad" ];
}
