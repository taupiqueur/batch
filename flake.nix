{
  description = "A tool for batch processing using your favorite text editor.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: {
    packages.aarch64-linux.default = import ./nix/package.nix nixpkgs.legacyPackages.aarch64-linux;
    packages.x86_64-linux.default = import ./nix/package.nix nixpkgs.legacyPackages.x86_64-linux;
    packages.aarch64-darwin.default = import ./nix/package.nix nixpkgs.legacyPackages.aarch64-darwin;
    packages.x86_64-darwin.default = import ./nix/package.nix nixpkgs.legacyPackages.x86_64-darwin;

    devShells.aarch64-linux.default = import ./nix/shell.nix nixpkgs.legacyPackages.aarch64-linux;
    devShells.x86_64-linux.default = import ./nix/shell.nix nixpkgs.legacyPackages.x86_64-linux;
    devShells.aarch64-darwin.default = import ./nix/shell.nix nixpkgs.legacyPackages.aarch64-darwin;
    devShells.x86_64-darwin.default = import ./nix/shell.nix nixpkgs.legacyPackages.x86_64-darwin;
  };
}
