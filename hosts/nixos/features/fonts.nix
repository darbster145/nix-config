{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    fira-code
    font-awesome
  ];
}
