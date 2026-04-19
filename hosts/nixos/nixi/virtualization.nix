{ pkgs, ... }:

{

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      swtpm.enable = true;
        ovmf = {
        enable = true;
        packages = [ (pkgs.OVMF.override { secureBoot = true; tpmSupport = true; }) ];
      };
    };
  };

  programs.virt-manager = {
    enable = true;
  };

}
