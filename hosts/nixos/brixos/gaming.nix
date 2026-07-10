{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  programs.gamemode.enable = true;

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  hardware.uinput.enable = true;

  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="input", SYMLINK+="uinput"
  '';

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/brad/.steam/root/compatibilitytools.d";
  };

  environment.systemPackages = with pkgs; [
    goverlay
    #heroic
    mangohud
    protonup-ng
  ];
}
