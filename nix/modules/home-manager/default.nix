{ config, lib, pkgs, settings, ... }:
{
  imports = [
    ./packages/git-branch-stash.nix
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
      fd
      jq
      neovim-unwrapped
      ripgrep
      tmux
      vivid
      # git plugins
      git-stack
      git-branchless
      # fzf plugins
      fzf-git-sh
      # zsh plugins
      zsh-completions
      zsh-fast-syntax-highlighting
      zsh-fzf-tab
      zsh-vi-mode
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
      g = "git";
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
    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = ''
        (
          fd - -exact-depth 1 - -type f - -strip-cwd-prefix - -hidden - -exclude '.git|~/Library' - -color= always;
          fd --exact-depth 2 --type f --strip-cwd-prefix --hidden --exclude '.git|~/Library' --color = always;
          fd --exact-depth 3 --type f --strip-cwd-prefix --hidden --exclude '.git|~/Library' --color = always;
          fd --exact-depth 4 --type f --strip-cwd-prefix --hidden --exclude '.git|~/Library' --color = always;
          fd --min-depth 5 --type f --strip-cwd-prefix --hidden --exclude '.git|~/Library' --color = always;
        ) | cat
      '';
      colors = {
        "bg" = "#1a1b26";
        "bg+" = "#292e42";
        "fg" = "#c0caf5";
        "fg+" = "#c0caf5";
        "header" = "#9ece6a";
        "hl" = "#ff9e64";
        "hl+" = "#ff9e64";
        "info" = "#7aa2f7";
        "marker" = "#9ece6a";
        "pointer" = "#7dcfff";
        "prompt" = "#7dcfff";
        "spinner" = "#9ece6a";
      };
      defaultOptions = [
        "--ansi"
        "--reverse"
        "--tabstop 2"
        "--border rounded"
        "--prompt '❯ '"
        "--pointer=''"
        "--marker='﫠'"
      ];
      changeDirWidgetCommand = "fd --type d --strip-cwd-prefix --hidden --follow --exclude .git --color=always";
      changeDirWidgetOptions = [
        "--ansi"
        "--preview 'tree -C {} | head -200'"
        "--preview-window border-rounded"
      ];
      fileWidgetCommand = ''
        (
          fd - -exact-depth 1 - -type f - -strip-cwd-prefix - -hidden - -exclude '.git|~/Library' - -color= always;
          fd --exact-depth 2 --type f --strip-cwd-prefix --hidden --exclude '.git|~/Library' --color = always;
          fd --exact-depth 3 --type f --strip-cwd-prefix --hidden --exclude '.git|~/Library' --color = always;
          fd --exact-depth 4 --type f --strip-cwd-prefix --hidden --exclude '.git|~/Library' --color = always;
          fd --min-depth 5 --type f --strip-cwd-prefix --hidden --exclude '.git|~/Library' --color = always;
        ) | cat
      '';
      fileWidgetOptions = [
        "--ansi"
        "--preview 'bat --style=numbers --color=always --line-range :500 {} --tabs 2'"
        "--preview-window border-rounded"
      ];
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
    git = {
      enable = true;
      userEmail = "maxime.doury@kraken.tech";
      userName = "Maxime Doury";
      aliases = {
        co = "checkout";
        br = "branch";
        c = "commit";
        st = "status";
        unstage = "reset HEAD - -";
        last = "log -1 --pretty=format:\"%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn]\" HEAD";
        cp = "cherry-pick";
        ls = "log - -pretty=format:\"%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn]\" --decorate";
        ll = "log --pretty=format:\"%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn]\" --decorate --numstat";
        recommit = "!git commit -eF $(git rev-parse --git-dir)/COMMIT_EDITMSG";
        next = "stack next";
        prev = "stack previous";
        reword = "stack reword";
        amend = "stack amend";
        sync = "stack sync";
        run = "stack run";
      };
      delta = {
        enable = true;
        options = {
          navigate = true;
          side-by-side = true;
          line-numbers = true;
          true-color = "always";
          features = "tokyonight";
        };
      };
      includes = [
        {
          path = "${config.xdg.configHome}/git/delta-themes.gitconfig";
        }
      ];
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        push = {
          autoSetupRemote = true;
        };
        pull = {
          rebase = true;
        };
        core = {
          ignorecase = false;
        };
        merge = {
          conflictstyle = "diff3";
        };
        diff = {
          colorMoved = "default";
        };
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
    zsh = {
      enable = true;
      enableCompletion = true;
      dotDir = ".config/zsh";
      autosuggestion = {
        enable = true;
        highlight = "fg=241";
      };
      plugins = with pkgs; [
        {
          name = "completions";
          src = zsh-completions;
        }
        {
          name = "fzf-tab";
          src = zsh-fzf-tab;
          file = "share/fzf-tab/fzf-tab.plugin.zsh";
        }
        {
          name = "fzf-tab-source";
          src = pkgs.fetchFromGitHub {
            owner = "Freed-Wu";
            repo = "fzf-tab-source";
            rev = "aabde06d1e82b839a350a8a1f5f5df3d069748fc";
            sha256 = "sha256-AJrbr2l2tRt42n9ZUmmGaDm10ydwm3fRDlXYI0LoXY0=";
          };
          file = "fzf-tab-source.plugin.zsh";
        }
        {
          name = "fzf-git";
          src = fzf-git-sh;
          file = "share/fzf-git-sh/fzf-git.sh";
        }
        {
          name = "vi-mode";
          src = zsh-vi-mode;
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }
        {
          name = "fast-syntax-highlighting";
          src = zsh-fast-syntax-highlighting;
          file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
        }
      ];
      envExtra = ''
        export ZVM_LINE_INIT_MODE=i
      '';

      # zvm_bindkey viins '^A' beginning-of-line
      # zvm_bindkey viins '^Z' end-of-line
      # zvm_bindkey viins '^B' clear-screen
      # zvm_bindkey viins '^H' backward-char
      # zvm_bindkey viins '^L' forward-char
      # zvm_bindkey viins '^K' up-line-or-history
      # zvm_bindkey viins 'jk' zvm_exit_insert_mode
      # zvm_bindkey viins 'kj' zvm_exit_insert_mode
      # zvm_bindkey viins '^O' backward-kill-line
      # zvm_bindkey viins '^E' fzf-cd-widget
      # zvm_bindkey viins '^I' fzf-completion
      # zvm_bindkey viins '^Y' autosuggest-accept

      # zvm_bindkey visual 'jk'  zvm_exit_visual_mode
      # zvm_bindkey visual 'kj'  zvm_exit_visual_mode
      # zvm_bindkey vicmd '^J'   down-history
      # zvm_bindkey vicmd 'J'    down-history
      # zvm_bindkey vicmd '^K'   up-history
      # zvm_bindkey vicmd 'K'    up-history
      # zvm_bindkey vicmd '^E'   fzf-cd-widget
      # zvm_bindkey vicmd '^I'   fzf-completion
      # zvm_bindkey vicmd '^Y'   autosuggest-accept

      initExtra = ''
        fpath+="$HOME/.config/zsh/plugins/completions/share/zsh/site-functions"

        autoload -U up-line-or-beginning-search
        zle -N up-line-or-beginning-search

        autoload -U down-line-or-beginning-search
        zle -N down-line-or-beginning-search

        # Key bindings (insert mode only)
        function zvm_after_init() {
          bindkey -v
          zvm_bindkey viins '^0' beginning-of-line
          zvm_bindkey viins '^$' end-of-line
          zvm_bindkey viins '^B' clear-screen
          zvm_bindkey viins "^Y" up-line-or-beginning-search
          zvm_bindkey viins "^U" down-line-or-beginning-search
          zvm_bindkey viins '^O' autosuggest-accept
          zvm_bindkey viins '[C' autosuggest-accept

          # fzf bindings
          zvm_bindkey viins '^E' fzf-cd-widget
          zvm_bindkey viins '^F' fzf-file-widget
          zvm_bindkey viins '^I' fzf-completion
          zvm_bindkey viins '^R' fzf-history-widget

          # Set insert mode keybindings for fzf-git.sh
          # https://github.com/junegunn/fzf-git.sh/issues/23
          for o in files branches tags remotes hashes stashes lreflogs each_ref; do
            eval "zvm_bindkey viins '^g^''\${o[1]}' fzf-git-$o-widget"
            eval "zvm_bindkey viins '^g''\${o[1]}' fzf-git-$o-widget"
          done
        }

        # Lazy keybindings (visual and command mode)
        function zvm_after_lazy_keybindings() {
          zvm_bindkey vicmd '^B' clear-screen
          zvm_bindkey vicmd "^Y" up-line-or-beginning-search
          zvm_bindkey vicmd "^U" down-line-or-beginning-search
          zvm_bindkey vicmd '^O' autosuggest-accept
          zvm_bindkey vicmd '[C' autosuggest-accept

          # fzf bindings
          zvm_bindkey vicmd '^E' fzf-cd-widget
          zvm_bindkey vicmd '^F' fzf-file-widget
          zvm_bindkey vicmd '^I' fzf-completion
          zvm_bindkey vicmd '^R' fzf-history-widget

          # Set normal and visual modes keybindings for fzf-git.sh
          # https://github.com/junegunn/fzf-git.sh/issues/23
          for o in files branches tags remotes hashes stashes lreflogs each_ref; do
            eval "zvm_bindkey vicmd '^g^''\${o[1]}' fzf-git-$o-widget"
            eval "zvm_bindkey vicmd '^g''\${o[1]}' fzf-git-$o-widget"
            eval "zvm_bindkey visual '^g^''\${o[1]}' fzf-git-$o-widget"
            eval "zvm_bindkey visual '^g''\${o[1]}' fzf-git-$o-widget"
          done
        }

        _fzf_comprun() {
          local command=$1
          shift
          case "$command" in
            cd)                   fzf "$@" --preview 'eza -T -L 2 --color always {} | head -200' ;;
            export|unset)         fzf "$@" --preview "eval 'echo \$'{}" ;;
            unalias)              fzf "$@" --preview 'alias {}' ;;
            ssh)                  fzf "$@" --preview 'dig {}' ;;
            *)                    fzf "$@" ;;
          esac
        }

      '';
    };
  };
}
