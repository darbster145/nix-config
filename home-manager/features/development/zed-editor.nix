{ config, pkgs, ... }:

{

 programs.zed-editor = {
   enable = true;
   extensions = [ "nix" "toml" "rust" ];
   userSettings = {
     theme = {
       mode = "system";
       dark = "One Dark";
       light = "One Light";
     };
     hour_format = "hour24";
     vim_mode = true;
   };
 };

}
