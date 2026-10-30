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

        # Slack requires a pre-registered Slack app. Create one at
        # https://api.slack.com/apps, export SLACK_CLIENT_ID / SLACK_CLIENT_SECRET,
        # remove "disabled", then sign in via /mcps.
        slack = {
          type = "remote";
          url = "https://mcp.slack.com/mcp";
          disabled = true;
          oauth = {
            client_id = "{env:SLACK_CLIENT_ID}";
            client_secret = "{env:SLACK_CLIENT_SECRET}";
            callback_port = 19876;
            redirect_uri = "http://127.0.0.1:19876/callback";
          };
        };
      };
    };
  };
}
