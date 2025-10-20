{ lib, pkgs, ... }:

let
  zedBaseSettings = {
    extensions = [
      # Languages
      "nix"
      "gosum"
      "cue"
      "rhai"
      "zig"
      "sql"
      # Templating
      "jsonnet"
      "jinja2"
      # Shells
      "basher"
      "nu"
      # Tools
      "proto"
      "log"
      "env"
      "live-server"
      # Build
      "make"
      "just"
      # DevOps
      "dockerfile"
      "docker-compose"
      "helm"
      "terraform"
      "kdl"
      # Formats
      "toml"
      "cargo-tom"
      "csv"
      "ini"
      "scheme"
      "asciidoc"
      "http"
      "marksman"
      "markdown-oxide"
      # Themes
      "catppuccin"
      "tokyo-night"
      "one-dark-pro"
      "catppuccin-blur"
    ];
    edit_predictions = {
      mode = "subtle";
      copilot = {
        proxy = null;
        proxy_no_verify = null;
      };
      enabled_in_text_threads = false;
    };
    telemetry = {
      metrics = false;
    };
    lsp = {
      nil = {
        initialization_options = {
          formatting.command = [ "nixfmt" ];
        };
      };
      nix = {
        binary = {
          path_lookup = true;
        };
      };
      rust-analyzer = {
        binary.path_lookup = true;
      };
      zls.binary.path_lookup = true;
    };
    languages = {
      Nix = {
        tab_size = 2;
        language_servers = [
          "!nil"
          "nixd"
        ];
      };
    };
    autosave.after_delay.milliseconds = 1000;
    tab_size = 2;
    vim_mode = false;
    soft_wrap = "editor_width";
    terminal = {
      copy_on_select = true;
      env = { };
    };
    ui_font_size = 25;
    buffer_font_size = 14;
    theme = {
      mode = "system";
      light = "One Light";
      dark = "Gruvbox Dark Hard";
    };
    show_whitespaces = "all";
  };
in
{
  programs.zed-editor = {
    enable = true;

    extraPackages = with pkgs; [
      alejandra
      basedpyright
      lua-language-server
      pylint
      nixd
      nil
      typescript
      typescript-language-server
      clang-tools
      neocmakelsp
      jsonnet-language-server
      nixfmt-rfc-style
      vscode-langservers-extracted
      python313Packages.python-lsp-server
      tailwindcss-language-server
    ];
  };
  home.activation.mergeZedSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ~/.config/zed
    if [ -f ~/.config/zed/settings.json ]; then
      tmpfile=$(mktemp)
      jq -s '.[0] * .[1]' \
        ${builtins.toFile "zedBase.json" (builtins.toJSON zedBaseSettings)} \
        ~/.config/zed/settings.json > "$tmpfile"
      mv "$tmpfile" ~/.config/zed/settings.json
    else
      echo '${builtins.toJSON zedBaseSettings}' > ~/.config/zed/settings.json
    fi
  '';
}
