{
  services.rpcbind.enable = true; # Required for NFS

  systemd.mounts = [{
    type = "nfs";
    mountConfig = { 
      Options = "noatime";
    };
    what = "10.0.0.3:/mnt/notonedrive/nfsgames";
    where = "/home/brad/nfsgames";
  }];

  systemd.automounts = [{
    wantedBy = [ "multi-user.target" ];
    automountConfig = { TimeoutIdleSec = "600"; };
    where = "/home/brad/nfsgames";
  }];
}

