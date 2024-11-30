{
  description = "my minimal flake";
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixpkgs-unstable";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
  };
  outputs =
    { nix-darwin
    , home-manager
    , nix-homebrew
    , homebrew-core
    , homebrew-cask
    , homebrew-bundle
    , ...
    }:
    let
      user = "maxime.doury";
      homeDirectory = "/Users/${user}";

      settings = {
        inherit user;
        inherit homeDirectory;
        dotfilesDirectory = "${homeDirectory}/.dotfiles";
        host = "OCTO-MAC-WYH6TXMFWD";
        system = "aarch64-darwin";
      };
    in
    {
      darwinConfigurations = {
        ${ settings.host} = nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit settings;
          };
          modules = [
            ./modules/nix-darwin
            home-manager.darwinModules.home-manager
            {

              users.users.${settings.user}.home = settings.homeDirectory;
              home-manager = {
                backupFileExtension = "backup";
                extraSpecialArgs = {
                  inherit settings;
                };
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${settings.user}.imports = [
                  ./modules/home-manager
                ];
              };
            }
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = true;
                user = settings.user;
                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                  "homebrew/homebrew-bundle" = homebrew-bundle;
                };
                mutableTaps = false;
              };
            }
          ];
        };
      };
    };
}
