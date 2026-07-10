{ pkgs, ... }:

{
  systemd.services.iscsi-login-games-fast = {
    description = "Login to iSCSI target iqn.2005-10.org.freenas.ctl:games-fast";
    after = [ "network.target" "iscsid.service" ];
    wants = [ "iscsid.service" ];
    serviceConfig = {
      ExecStartPre = "${pkgs.openiscsi}/bin/iscsiadm -m discovery -t sendtargets -p 10.0.0.3";
      ExecStart = "${pkgs.openiscsi}/bin/iscsiadm -m node -T iqn.2005-10.org.freenas.ctl:games-fast -p 10.0.0.3 --login";
      ExecStop = "${pkgs.openiscsi}/bin/iscsiadm -m node -T iqn.2005-10.org.freenas.ctl:games-fast -p 10.0.0.3 --logout";
      Restart = "on-failure";
      RemainAfterExit = true;
    };
    wantedBy = [ "multi-user.target" ];
  };

  fileSystems."/home/brad/GamesFast" = {
    device = "/dev/disk/by-uuid/3D2740BF6ECFCC95";
    fsType = "ntfs3";
    options = [
      "_netdev"
      "nofail"
      "windows_names"
      #"noacsrules"
      "uid=1000"
      "force"
    ];
  };
}
