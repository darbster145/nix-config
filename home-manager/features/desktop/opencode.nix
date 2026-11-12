{ config, pkgs, ... }:

{
  sops.secrets.github_pat = { };

  programs.opencode = {
    enable = true;

    validateFiles.config = true;

    settings = {
      plugins = [ "opencode-claude-auth@latest" ];

      mcp.servers = {
        linear = {
          type = "remote";
          url = "https://mcp.linear.app/mcp";
        };

        github = {
          type = "remote";
          url = "https://api.githubcopilot.com/mcp/";
          oauth = false;
          headers = {
            Authorization = "Bearer {file:${config.sops.secrets.github_pat.path}}";
          };
        };

        datadog = {
          type = "remote";
          url = "https://mcp.us5.datadoghq.com/v1/mcp";
        };

        rippling = {
          type = "remote";
          url = "https://mcp.rippling.com/mcp";
        };
      };
    };
  };
}
