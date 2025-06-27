{ pkgs, lib, ... }:
{
  imports = [
    ./packages.nix
  ];
  home = {
    username = "ivan";
    homeDirectory = "/home/ivan";
    stateVersion = "25.05";
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      zed = "zeditor";
      cls = "clear";
      ll = "ls -la";
      re = "sudo nixos-rebuild switch --flake ~/nix#nixos && sh /home/ivan/nix/build.sh";
      helix = "hx";
    };
  };
  programs.git = {
    enable = true;
    userName = "MisTerio487";
    userEmail = "ipkovalenko2006@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };
  programs.zed-editor = {
    enable = true;
    extraPackages = with pkgs; [
      alejandra
      lua-language-server
      pyright
      pylint
      nixd
      nil
      clang-tools
      neocmakelsp
      jsonnet-language-server
      nixfmt-rfc-style
      vscode-langservers-extracted
      tailwindcss-language-server
    ];
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
      # Themes
      "catppuccin"
      "tokyo-night"
      "one-dark-pro"
      "catppuccin-blur"
    ];
    userSettings = {
      features = {
        inline_completion_provider = "none";
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
            "nil"
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
      ui_font_size = lib.mkForce 25;
      buffer_font_size = lib.mkForce 25;
      theme = lib.mkForce {
        mode =  "system";
        light = "One Light";
        dark = "Gruvbox Dark Hard";
      };
      show_whitespaces = "all";
    };
  };
  programs.home-manager.enable = true;
}
