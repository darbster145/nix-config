{
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    loadModels = [
      "deepseek-r1:14b"
      "deepseek-r1:32b"
      "deepseek-coder-v2:16b"
      "gtp-oss:20b"
      "mistral:7b"
      "qwen3:32b"
      "gpt-oss:20b"
      "gemma3:27b"
    ];
    rocmOverrideGfx = "11.0.0";
    openFirewall = true;
  };

  services.open-webui = {
    enable = true;
    host = "0.0.0.0";
    openFirewall = true;
  };
}
