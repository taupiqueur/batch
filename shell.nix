let
  pkgs = import <nixpkgs> {
  };
in
  pkgs.mkShell {
    packages = [
      pkgs.crystal
      pkgs.shards
      pkgs.git
      pkgs.mandoc
    ];
  }
