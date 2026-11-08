{
  # The Nix daemon connects as root, so trust the builder system-wide.
  programs.ssh.knownHosts.brixos = {
    hostNames = [
      "brixos"
      "brixos.polecat-alpha.ts.net"
      "100.78.71.10"
    ];
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGGHkCM4SpgdAi2p2930S+zOPA5lbY4z+v0mUbkglZgE";
  };

  # 1. Enable distributed builds on the client
  nix.distributedBuilds = true;

  # 2. Tell the client to let the remote builder fetch its own dependencies
  nix.settings.builders-use-substitutes = true;

  # 3. Define the build server connection details
  nix.buildMachines = [
    {
      hostName = "brixos"; # Change to your server's IP/hostname
      sshUser = "nixremote";

      # Path to the private SSH key on the CLIENT machine
      sshKey = "/root/.ssh/id_build_machine";

      # The system architecture of the build server
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      # Supported architectures (e.g., if it emulates aarch64)
      supportedFeatures = [
        "big-parallel"
        "kvm"
        "nixos-test"
      ];

      # Maximum concurrent jobs the client should send to this server
      maxJobs = 16;
    }
  ];
}
