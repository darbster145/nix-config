{ pkgs, ... }:

{
  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  # Plasma enables KMail/Kontact/Merkuro by default, which pull in Akonadi.
  programs.kde-pim.enable = false;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    discover
    elisa
    khelpcenter
    krdp
  ];
}
