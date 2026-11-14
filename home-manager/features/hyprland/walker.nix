let
  c = import ./palette.nix;
in
{
  # Walker only reads these at start; restart it with `pkill walker` after changes.
  xdg.configFile."walker/config.toml".text = ''
    theme = "tokyonight"
  '';

  # Overrides walker's default style.css; layouts fall back to the defaults.
  xdg.configFile."walker/themes/tokyonight/style.css".text = ''
    * {
      all: unset;
      font-family: "Adwaita Sans";
    }

    popover {
      background: ${c.bgHighlight};
      border: 1px solid ${c.border};
      border-radius: 10px;
      padding: 10px;
    }

    .normal-icons {
      -gtk-icon-size: 16px;
    }

    .large-icons {
      -gtk-icon-size: 32px;
    }

    scrollbar {
      opacity: 0;
    }

    .box-wrapper {
      box-shadow: 0 12px 32px rgba(0, 0, 0, 0.4);
      background: ${c.bg};
      padding: 16px;
      border-radius: 12px;
      border: 1px solid ${c.border};
    }

    .preview-box,
    .elephant-hint,
    .placeholder,
    .list,
    .keybinds {
      color: ${c.fg};
    }

    .input {
      caret-color: ${c.blue};
      background: ${c.bgDark};
      padding: 10px 12px;
      border-radius: 8px;
      color: ${c.fg};
    }

    .input placeholder {
      color: ${c.comment};
    }

    .input selection {
      background: ${c.bgHighlight};
    }

    .item-box {
      border-radius: 8px;
      padding: 8px 10px;
    }

    .item-quick-activation {
      background: ${c.bgHighlight};
      border-radius: 6px;
      padding: 8px;
    }

    child:selected .item-box,
    row:selected .item-box {
      background: ${c.bgHighlight};
    }

    child:selected .item-text,
    row:selected .item-text {
      color: ${c.blue};
    }

    .item-subtext {
      font-size: 12px;
      color: ${c.comment};
    }

    .item-image-text {
      font-size: 28px;
    }

    .preview {
      border: 1px solid ${c.border};
      border-radius: 8px;
      color: ${c.fg};
    }

    .preview .large-icons {
      -gtk-icon-size: 64px;
    }

    .calc .item-text {
      font-size: 24px;
    }

    .symbols .item-image {
      font-size: 24px;
    }

    .keybinds {
      padding-top: 10px;
      border-top: 1px solid ${c.bgHighlight};
      font-size: 12px;
    }

    .keybind-button {
      opacity: 0.5;
    }

    .keybind-button:hover {
      opacity: 0.75;
    }

    .keybind-bind {
      text-transform: lowercase;
      opacity: 0.35;
    }

    .keybind-label {
      padding: 2px 4px;
      border-radius: 4px;
      border: 1px solid ${c.comment};
    }

    .error {
      padding: 10px;
      background: ${c.red};
      color: ${c.bg};
    }
  '';
}
