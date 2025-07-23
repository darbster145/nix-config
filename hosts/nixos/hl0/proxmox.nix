{ pkgs, lib, config, ... }: 

{

  services.proxmox-ve = {
    enable = true;
    ipAddress = "10.0.0.2";
  };

  nixpkgs.overlays = [
    proxmox-nixos.overlays.x86_64-linux.proxmox-ve
  ];

}
