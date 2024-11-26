{ lib, pkgs, ... }: {
  # darwin preferences and configuration
  environment = {
    shells = with pkgs; [
      bash
      zsh
      nushell
    ];
    pathsToLink = [ "/Applications" "/usr/share/zsh" ];
    systemPackages = with pkgs; [
      _1password-cli
      arc-browser
      docker
      google-chrome
      mos
      raycast
      slack
      vscode
      zoom-us
    ];
  };
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs = {
    config = {
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "1password-cli"
        "arc-browser"
        "google-chrome"
        "mos"
        "raycast"
        "slack"
        "vscode"
        "zoom"
      ];
    };
    hostPlatform = "aarch64-darwin";
  };
  fonts = {
    packages = [
      (pkgs.nerdfonts.override { fonts = [ "GeistMono" ]; })
    ];
  };
  programs = {
    zsh = {
      enable = true;
    };
  };
  security.pam.enableSudoTouchIdAuth = true;
  services = {
    nix-daemon = {
      enable = true;
    };
  };
  system = {
    stateVersion = 5;
    defaults = {
      dock.autohide = true;
      NSGlobalDomain._HIHideMenuBar = true;
    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };
  homebrew = {
    enable = true;
    brews = [
      "n"
    ];
    casks = [
      "1password"
      "homerow"
      "miro"
      "via"
    ];
  };
}
