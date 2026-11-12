{ config, pkgs, ... }:

{
  sops.secrets.github_pat = { };

  home.packages = [ pkgs.opencode-claude-auth ];

  programs.opencode = {
    enable = true;

    validateFiles.config = true;

    settings = {
      plugins = [ "opencode-claude-auth@latest" ];

      mcp.servers = {
        github = {
          type = "remote";
          url = "https://api.githubcopilot.com/mcp/";
          oauth = false;
          headers = {
            Authorization = "Bearer {file:${config.sops.secrets.github_pat.path}}";
          };
        };

        radar = {
          type = "remote";
          url = "http://127.0.0.1:52551/mcp";
          oauth = false;
        };
      };
    };
  };
}
