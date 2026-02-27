{ inputs, config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    nixos-rebuild
    zsh
    sshfs
    macfuse-stubs
    home-manager
    disk-inventory-x
    remmina
    zoxide
    spacebar
    powershell
    cargo
    mkalias
    raycast
    slack
    nmap
    yazi
    kanata-with-cmd
    wireshark
    lunar
    utm
    python3
    inputs.self.packages.${pkgs.system}.freelens-bin
    ghostty-bin
    zenmap
  ];

  programs._1password = {
    enable = true;
  };
  programs._1password-gui = {
    enable = true;
    package = pkgs._1password-gui-beta;
  };

}
