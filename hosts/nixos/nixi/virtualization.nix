{ pkgs, ... }:

{

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      swtpm.enable = true;
    };
  };

  programs.virt-manager = {
    enable = true;
  };

}
