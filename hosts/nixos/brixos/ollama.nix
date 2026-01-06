{ pkgs, ... }:

{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
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
    environmentVariables = {
      HCC_AMDGPU_TARGET = "gfx1100";
    };
    openFirewall = true;
  };

  services.open-webui = {
    enable = true;
    host = "0.0.0.0";
    openFirewall = true;
  };
}
