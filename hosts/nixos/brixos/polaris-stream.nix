{ ... }:

{
  services.polaris-stream = {
    enable = true;
    autoStart = true;
    openFirewall = true;

    settings = {
      port = 48989;
      sunshine_name = "brixos-polaris";
      encoder = "vaapi";
      headless_mode = "enabled";
      linux_use_cage_compositor = "enabled";
      linux_prefer_gpu_native_capture = "disabled";
      adaptive_bitrate_enabled = "enabled";
      hdr_mode = 0;
      color_range = 1;
      max_sessions = 2;
    };
  };
}
