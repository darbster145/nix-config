{ lib, ... }:

let
  assoc = app: types: lib.genAttrs types (_: app);
in
{
  # Shared by Hyprland and Plasma. App URL handlers (logins etc.) still work:
  # they come from each app's own .desktop file.
  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      assoc "zen-beta.desktop" [
        "text/html"
        "application/xhtml+xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/about"
        "x-scheme-handler/unknown"
      ]
      // assoc "org.kde.dolphin.desktop" [ "inode/directory" ]
      // assoc "org.kde.okular.desktop" [
        "application/pdf"
        "application/epub+zip"
      ]
      // assoc "org.kde.gwenview.desktop" [
        "image/png"
        "image/jpeg"
        "image/gif"
        "image/webp"
        "image/avif"
        "image/bmp"
        "image/tiff"
        "image/svg+xml"
        "image/heic"
      ]
      // assoc "mpv.desktop" [
        "video/mp4"
        "video/x-matroska"
        "video/webm"
        "video/quicktime"
        "video/x-msvideo"
        "video/mpeg"
        "audio/mpeg"
        "audio/flac"
        "audio/ogg"
        "audio/opus"
        "audio/wav"
        "audio/x-wav"
        "audio/mp4"
        "audio/aac"
      ]
      // assoc "org.kde.kate.desktop" [
        "text/plain"
        "text/markdown"
        "application/json"
        "application/x-shellscript"
        "application/xml"
      ]
      // assoc "org.kde.ark.desktop" [
        "application/zip"
        "application/x-tar"
        "application/x-compressed-tar"
        "application/x-xz-compressed-tar"
        "application/x-zstd-compressed-tar"
        "application/gzip"
        "application/x-7z-compressed"
        "application/vnd.rar"
      ];
  };

  # Plasma writes this file too; let home-manager own it.
  xdg.configFile."mimeapps.list".force = true;
}
