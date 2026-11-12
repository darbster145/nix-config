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
      url = "https://mcp.rippling.com/mcp";
    };
  };
}
