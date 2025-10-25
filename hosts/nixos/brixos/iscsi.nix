{ pkgs, ... }:

{
  systemd.services.iscsi-login-games = {
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

  fileSystems."/home/brad/Games" = {
    device = "/dev/disk/by-uuid/B660927760923E55";
    fsType = "ntfs3";
    options = [
      "_netdev"
      "nofail"
      "rw"
      "uid=1000"
    ];
  };

  boot.supportedFilesystems = [ "ntfs" ];

  boot.kernelModules = [ "ntfs3" "nls_utf8" ];
}

