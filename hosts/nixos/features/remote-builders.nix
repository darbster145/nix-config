{
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
      systems = [ "x86_64-linux" "aarch64-linux" ];
      
      # Supported architectures (e.g., if it emulates aarch64)
      supportedFeatures = [ "big-parallel" "kvm" "nixos-test" ];
      
      # Maximum concurrent jobs the client should send to this server
      maxJobs = 16;
    }
  ];
}


