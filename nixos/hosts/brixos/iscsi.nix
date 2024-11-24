{ pkgs, ... }:

{
  systemd.services.iscsi-login-lingames = {
    description = "Login to iSCSI target iqn.2005-10.org.freenas.ctl:lingames";
    after = [ "network.target" "iscsid.service" ];
    wants = [ "iscsid.service" ];
    serviceConfig = {
      ExecStartPre = "${pkgs.openiscsi}/bin/iscsiadm -m discovery -t sendtargets -p 10.0.0.3";
      ExecStart = "${pkgs.openiscsi}/bin/iscsiadm -m node -T iqn.2005-10.org.freenas.ctl:lingames -p 10.0.0.3 --login";
      ExecStop = "${pkgs.openiscsi}/bin/iscsiadm -m node -T iqn.2005-10.org.freenas.ctl:lingames -p 10.0.0.3 --logout";
      Restart = "on-failure";
      RemainAfterExit = true;
    };
    wantedBy = [ "multi-user.target" ];
  };

  fileSystems."/home/brad/Games" = {
    device = "/dev/disk/by-path/ip-10.0.0.3:3260-iscsi-iqn.2005-10.org.freenas.ctl:lingames-lun-0"; # Replace with the correct device path after iSCSI login
    fsType = "ext4"; # Or the correct filesystem type
    options = [ "_netdev" "nofail" ]; # Ensures network is up before mounting
  };

  systemd.services.iscsi-login-test = {
    description = "Login to iSCSI target iqn.2005-10.org.freenas.ctl:games";
    after = [ "network.target" "iscsid.service" ];
    wants = [ "iscsid.service" ];
    serviceConfig = {
      ExecStartPre = "${pkgs.openiscsi}/bin/iscsiadm -m discovery -t sendtargets -p 10.0.0.3";
      ExecStart = "${pkgs.openiscsi}/bin/iscsiadm -m node -T iqn.2005-10.org.freenas.ctl:games -p 10.0.0.3 --login";
      ExecStop = "${pkgs.openiscsi}/bin/iscsiadm -m node -T iqn.2005-10.org.freenas.ctl:games -p 10.0.0.3 --logout";
      Restart = "on-failure";
      RemainAfterExit = true;
    };
    wantedBy = [ "multi-user.target" ];
  };

  fileSystems."/home/brad/test" = {
    device = "/dev/sdb2"; # Replace with the correct device path after iSCSI login
    fsType = "ntfs-3g"; # Or the correct filesystem type
    options = [ "_netdev" "nofail" "rw" "uid=1000" ]; # Ensures network is up before mounting
  };
}
