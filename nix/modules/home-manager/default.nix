{ config, lib, pkgs, settings, ... }:
{
  imports = [
    ./packages/git.nix
    ./packages/git-branch-stash.nix
    ./packages/fzf.nix
    ./packages/zsh.nix
  ];
  # home-manager configuration
  home = {
    stateVersion = "24.05";
    homeDirectory = settings.homeDirectory;
    preferXdgDirectories = true;
    packages = with pkgs; [
      # dev
      corepack_latest
      bun
      nodePackages_latest.vercel
      wezterm
      # ui
      aerospace
      jankyborders
      sketchybar
      # cli
      curl
      neovim-unwrapped
      vivid
    ];
    sessionVariables = {
      CLICOLOR = 1;
      EDITOR = "nvim";
      FORCE_COLOR = 1;
      LS_COLOR = "$(vivid generate ${config.xdg.configHome}/vivid/themes/tokyonight.yml)";
      PAGER = "bat";
      TURBO_UI = "true";
    };
    shellAliases = {
      rebuild = "darwin-rebuild switch --flake ~/.dotfiles/nix";
      cat = "bat";
      p = "pnpm";
      v = "nvim";
      vi = "nvim";
      vim = "nvim";
    };
  };
  xdg = {
    enable = true;
    configFile = with config.lib.file; {
      # https://github.com/nikitabobko/AeroSpace
      aerospace = {
        source = mkOutOfStoreSymlink "${settings.dotfilesDirectory}/aerospace";
      };
      # https://github.com/FelixKratz/JankyBorders
      borders = {
        source = mkOutOfStoreSymlink "${settings.dotfilesDirectory}/borders";
      };
      delta = {
        source = mkOutOfStoreSymlink "${settings.dotfilesDirectory}/delta";
      };
      # https://github.com/neovim/neovim
      nvim = {
        source = mkOutOfStoreSymlink "${settings.dotfilesDirectory}/nvim";
      };
      # https://github.com/FelixKratz/SketchyBar
      sketchybar = {
        source = mkOutOfStoreSymlink "${settings.dotfilesDirectory}/sketchybar";
      };
      wezterm = {
        source = mkOutOfStoreSymlink "${settings.dotfilesDirectory}/wezterm";
      };
      # https://github.com/sharkdp/vivid
      "vivid/themes/tokyonight.yml" =
        let
          vivid = pkgs.fetchFromGitHub {
            owner = "sharkdp";
            repo = "vivid";
            rev = "v0.10.1";
            sha256 = "sha256-mxBBfezaMM2dfiXK/s+Htr+i5GJP1xVSXzkmYxEuwNs=";
          };
        in
        {
          source = "${vivid}/themes/tokyonight-night.yml";
        };
    };
  };
  programs = {
    home-manager = {
      enable = true;
    };
    bat = {
      enable = true;
      config = {
        theme = "tokyonight";
      };
      themes = {
        tokyonight = {
          src = pkgs.fetchFromGitHub {
            owner = "folke";
            repo = "tokyonight.nvim";
            rev = "v4.1.0";
            sha256 = "sha256-RPz0SoB11c/8fN4yS15pzCcEUElnsVk6wHj2dQbBLNk=";
          };
          file = "extras/sublime/tokyonight_night.tmTheme";
        };
      };
    };
    eza = {
      enable = true;
      enableZshIntegration = true;
      colors = "auto";
      extraOptions = [ "--group-directories-first" "--header" ];
      git = true;
      icons = "auto";
    };
    gh = {
      enable = true;
      extensions = [ ];
      settings = {
        git_protocol = "https";
        prompt = "enabled";
        aliases = {
          co = "pr checkout";
          v = "pr view";
        };
        pager = "delta";
      };
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        command_timeout = 1000;
        format = lib.concatStrings [
          "[](fg:teal)"
          "$directory"
          "[](bg:green1 fg:teal)"
          "$git_branch"
          "$git_state"
          "$git_status"
          "[](bg:blue6 fg:green1)"
          "$cmd_duration"
          "$character"
          "[ ](fg:blue6)"
        ];
        directory = {
          format = "[$path]($style)";
          style = "bg:teal fg:bg";
          repo_root_format = "[$before_root_path]($before_repo_root_style)[$repo_root]($repo_root_style)[$path]($style)";
          repo_root_style = "bg:teal fg:bg bold";
        };
        character = {
          format = "$symbol";
          success_symbol = "[ ❯](bg:blue6 fg:teal)";
          error_symbol = "[ ❯](bg:blue6 fg:purple)";
          vimcmd_symbol = "[ ❮](bg:blue6 fg:teal)";
        };
        git_branch = {
          format = "[ $branch](bg:green1 fg:bg)";
        };
        git_status = {
          format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](bg:green1 fg:bg) ($ahead_behind$stashed)](bg:green1 fg:bg)";
          conflicted = "";
          untracked = "";
          modified = "";
          staged = "";
          renamed = "";
          deleted = "";
          stashed = "≡";
        };
        git_state = {
          format = "[\($state( $progress_current/$progress_total)\) ](bg:green1 fg:bg)";
        };
        cmd_duration = {
          format = "[ $duration](bg:blue6 fg:teal bold)";
        };
        palette = "tokyonight";
        palettes = {
          tokyonight = {
            none = "NONE";
            bg_dark = "#1f2335";
            bg = "#24283b";
            bg_highlight = "#292e42";
            terminal_black = "#414868";
            fg = "#c0caf5";
            fg_dark = "#ffffff";
            fg_gutter = "#3b4261";
            dark3 = "#545c7e";
            comment = "#565f89";
            dark5 = "#737aa2";
            blue0 = "#3d59a1";
            blue = "#7aa2f7";
            cyan = "#7dcfff";
            blue1 = "#2ac3de";
            blue2 = "#0db9d7";
            blue5 = "#89ddff";
            blue6 = "#b4f9f8";
            blue7 = "#394b70";
            magenta = "#bb9af7";
            magenta2 = "#ff007c";
            purple = "#9d7cd8";
            orange = "#ff9e64";
            yellow = "#e0af68";
            green = "#9ece6a";
            green1 = "#73daca";
            green2 = "#41a6b5";
            teal = "#1abc9c";
            red = "#f7768e";
            red1 = "#db4b4b";
          };
        };
      };
    };
    # wezterm = {
    #   enable = true;
    #   enableZshIntegration = true;
    #   extraConfig = builtins.readFile config.lib.file.mkOutOfStoreSymlink "${settings.dotfilesDir}/wezterm/wezterm.lua";
    # };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
