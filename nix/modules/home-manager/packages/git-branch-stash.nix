{ pkgs, ... }:

let
  git-branch-stash = pkgs.rustPlatform.buildRustPackage
    rec {
      pname = "git-branch-stash";
      version = "v0.11.1";
      src = pkgs.fetchFromGitHub {
        owner = "gitext-rs";
        repo = pname;
        rev = version;
        sha256 = "sha256-aY2gHECrvCQ7zz8IrT11VXiMRpd8Y5XlpQs6oAB/k/s=";
      };
      cargoHash = "sha256-f1/XqPmMlmwX4DrAwAYLswWHCmhGm5vcG/6g9lxOL5M=";
    };

in
{
  home.packages = [
    git-branch-stash
  ];
}

