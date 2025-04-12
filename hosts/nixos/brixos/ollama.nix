{
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    loadModels = [ 
      "deepseek-r1:14b"
      "deepseek-r1:32b"
      "deepseek-coder-v2:16b"
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
