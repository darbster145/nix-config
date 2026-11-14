{
  config,
  pkgs,
  ...
}:

let
  # nvim-treesitter with its parsers prebuilt by Nix, so nothing compiles at runtime.
  # Its queries live in runtime/queries; expose them at the top level where Neovim looks.
  treesitter = pkgs.symlinkJoin {
    name = "nvim-treesitter-with-grammars";
    paths = [
      pkgs.vimPlugins.nvim-treesitter
    ]
    ++ (with pkgs.vimPlugins.nvim-treesitter.grammarPlugins; [
      bash
      c
      css
      diff
      git_rebase
      gitcommit
      go
      gomod
      gosum
      html
      javascript
      jsdoc
      json
      lua
      luadoc
      markdown
      markdown_inline
      nix
      python
      query
      regex
      rust
      toml
      tsx
      typescript
      vim
      vimdoc
      yaml
    ]);
    postBuild = "ln -s $out/runtime/queries $out/queries";
  };
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withPython3 = true;
    withRuby = true;

    # Language servers and formatters, installed by Nix instead of Mason.
    extraPackages = with pkgs; [
      # Nix
      nixd
      nixfmt
      # Lua
      lua-language-server
      stylua
      # Python
      basedpyright
      ruff
      # Go
      gopls
      gofumpt
      # TypeScript/JavaScript, HTML, CSS, JSON, YAML, Markdown formatting
      vtsls
      prettierd
      # Rust
      rust-analyzer
      rustfmt
      # Bash
      bash-language-server
      shfmt
      shellcheck
      # YAML / Kubernetes
      yaml-language-server
      # Markdown
      marksman
    ];

    initLua = ''require("config")'';
  };

  # The Lua config lives in ./nvim; plugins are managed by lazy.nvim.
  xdg.configFile = {
    "nvim/lua/config".source = ./nvim/lua/config;
    "nvim/lua/plugins".source = ./nvim/lua/plugins;

    # Nix store paths and machine details the Lua config needs.
    "nvim/lua/nix_paths.lua".text = ''
      return {
        treesitter = "${treesitter}",
        blink_cmp = "${pkgs.vimPlugins.blink-cmp}",
        flake = "${config.home.homeDirectory}/.config/nix-config",
        username = "${config.home.username}",
      }
    '';
  };
}
