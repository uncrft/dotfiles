{ config, lib, pkgs, settings, ... }:

let

  withDelta = config.programs.git.delta.enable;

in

{
  home.packages = with pkgs;
    [
      git-stack
      git-branchless
    ];

  home.shellAliases = {
    g = "git";
  };


  xdg.configFile = {
    delta = {
      enable = withDelta;
      source = config.lib.file.mkOutOfStoreSymlink "${settings.dotfilesDirectory}/delta";
    };
  };

  programs.git = {
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
      ls = "log --pretty=format:\"%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn]\" --decorate";
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
    includes = lib.lists.optionals withDelta [
      {
        path = "${config.xdg.configHome}/delta/themes.gitconfig";
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
      rerere = {
        enabled = true;
      };
    };
  };
}
