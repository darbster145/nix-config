{ pkgs, ... }:

{
  # LACT systemd service for the BrixOS AMD GPU.
  systemd.services.lact = {
    description = "AMDGPU Control Daemon";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
    enable = true;
  };

  environment.systemPackages = [ pkgs.lact ];
}
