<<<<<<< Updated upstream
{ pkgs, ... }:
||||||| Stash base
{ config, lib, pkgs, ... }:
let
  enableFzfIntegration = config.programs.fzf.enable && config.programs.fzf.enableZshIntegration;
  fzfIntegration = {
    plugins = with pkgs; lib.lists.optionals enableFzfIntegration [
      {
        name = "fzf-git";
        src = fzf-git-sh;
        file = "share/fzf-git-sh/fzf-git.sh";
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
    ];
=======
{ config, lib, pkgs, ... }:
let
  withFzf = config.programs.fzf.enable && config.programs.fzf.enableZshIntegration;
  fzfIntegration = {
    plugins = with pkgs; lib.lists.optionals withFzf [
      {
        name = "fzf-git";
        src = fzf-git-sh;
        file = "share/fzf-git-sh/fzf-git.sh";
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
    ];
>>>>>>> Stashed changes

<<<<<<< Updated upstream
||||||| Stash base
    zvm_after_init = lib.strings.optionalString enableFzfIntegration ''

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
    '';

    zvm_after_lazy_keybindings = lib.strings.optionalString enableFzfIntegration ''

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
    '';
  };


in
=======
    zvm_after_init = lib.strings.optionalString withFzf ''

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
    '';

    zvm_after_lazy_keybindings = lib.strings.optionalString withFzf ''

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
    '';
  };


in
>>>>>>> Stashed changes
{
  home.packages = with pkgs; [
    zsh-completions
    zsh-fast-syntax-highlighting
    zsh-fzf-tab
    zsh-vi-mode

  ];
  programs.zsh = {
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

}
