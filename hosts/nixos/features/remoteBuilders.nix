{
  nix.buildMachines = [
    {
      hostName = "10.0.0.11";
      sshUser = "nixremote";
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      sshKey = "/home/brad/.ssh/remotebuild";
      protocol = "ssh-ng";
      maxJobs = 32;
      speedFactor = 1;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    }
    {
      hostName = "100.82.172.52";
      sshUser = "nixremotet";
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      sshKey = "/home/brad/.ssh/remotebuildt";
      protocol = "ssh-ng";
      maxJobs = 32;
      speedFactor = 1;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    }

  ];

  nix.distributedBuilds = true;
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';
  nix.settings.trusted-users = [ "nixremote" "nixremotet" ];

  programs.ssh.extraConfig = ''
    Host 10.0.0.11
      Port 22
      User nixremote
      IdentitiesOnly yes
      IdentityFile ~/.ssh/remotebuild

    Host 100.82.172.52
      Port 22
      User nixremotet
      IdentitiesOnly yes
      IdentityFile ~/.ssh/remotebuildt

  '';
}
