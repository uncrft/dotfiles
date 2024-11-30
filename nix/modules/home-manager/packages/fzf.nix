{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bat
    eza
    fd
    ripgrep
    fzf-git-sh
    zsh-fzf-tab
  ];
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = '' (
        fd --exact-depth 1 --type f --strip-cwd-prefix --hidden --exclude='.git' --exclude='~/Library' --color=always;
        fd --exact-depth 2 --type f --strip-cwd-prefix --hidden --exclude='.git' --exclude='~/Library' --color=always;
        fd --exact-depth 3 --type f --strip-cwd-prefix --hidden --exclude='.git' --exclude='~/Library' --color=always;
        fd --exact-depth 4 --type f --strip-cwd-prefix --hidden --exclude='.git' --exclude='~/Library' --color=always;
        fd --min-depth 5 --type f --strip-cwd-prefix --hidden --exclude='.git' --exclude='~/Library' --color=always;
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
      "--preview 'eza -T -L 2 --color {} | head -200'"
      "--preview-window border-rounded"
    ];
    fileWidgetCommand = ''
      (
        fd --exact-depth 1 --type f --strip-cwd-prefix --hidden --exclude='.git' --exclude='~/Library' --color=always;
        fd --exact-depth 2 --type f --strip-cwd-prefix --hidden --exclude='.git' --exclude='~/Library' --color=always;
        fd --exact-depth 3 --type f --strip-cwd-prefix --hidden --exclude='.git' --exclude='~/Library' --color=always;
        fd --exact-depth 4 --type f --strip-cwd-prefix --hidden --exclude='.git' --exclude='~/Library' --color=always;
        fd --min-depth 5 --type f --strip-cwd-prefix --hidden --exclude='.git' --exclude='~/Library' --color=always;
      ) | cat
    '';
    fileWidgetOptions = [
      "--ansi"
      "--preview 'bat --style=numbers --color=always --line-range :500 {} --tabs 2'"
      "--preview-window border-rounded"
    ];
  };
}
