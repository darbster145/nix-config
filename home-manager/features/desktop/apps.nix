{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # Productivity
    obsidian           # Note-taking and knowledge management
    
    # Security
    bitwarden-desktop  # Password manager
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    # Linux-only packages
    libreoffice        # Office suite
    signal-desktop     # Private messaging
  ];
}
