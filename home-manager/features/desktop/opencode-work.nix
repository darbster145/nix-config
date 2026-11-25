{
  programs.opencode.settings.mcp.servers = {
    linear = {
      type = "remote";
      url = "https://mcp.linear.app/mcp";
    };

    datadog = {
      type = "remote";
      url = "https://mcp.us5.datadoghq.com/v1/mcp";
    };

    rippling = {
      type = "remote";
      url = "https://mcpgateway.rippling.com/api/v1/proxy/6a6cbe8c5b976ff037e43566/mcp";
    };

    notion = {
      type = "remote";
      url = "https://mcp.notion.com/mcp";
    };

    slack = {
      type = "remote";
      url = "https://mcp.slack.com/mcp";
    };

    drata = {
      type = "remote";
      url = "https://mcp.drata.com/mcp/";
    };
  };
}
