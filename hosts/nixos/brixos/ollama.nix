{ pkgs, ... }:

{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    #loadModels = [
    #  "deepseek-r1:14b"
    #  "deepseek-r1:32b"
    #  "deepseek-coder-v2:16b"
    #  "deepseek-ocr:3b"
    #  "gtp-oss:20b"
    #  "mistral:7b"
    #  "qwen3.6:35b"
    #  "gpt-oss:20b"
    #  "gemma4:31b"
    #];
    rocmOverrideGfx = "11.0.0";
    environmentVariables = {
      HCC_AMDGPU_TARGET = "gfx1100";
    };
    openFirewall = true;
    #syncModels = true;
  };

  services.open-webui = {
    enable = true;
    host = "0.0.0.0";
    openFirewall = true;
  };

  services.litellm = {
    enable = true;
    openFirewall = true;
    port = 4000;
    host = "0.0.0.0";
    environmentFile = "/var/lib/secrets/liteLLMSecrets";
  };
}
