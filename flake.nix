{
  description = "dotfiles";

  inputs = {
    # uses pinned version for reproducibility and stability
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

    # uses pinned version for reproducibility and stability
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      ...
    }:
    let
      # Change this when using the configuration on another machine.
      user = "simhadriholagundhi";
    in
    {
      darwinConfigurations.mac = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit user; };
        modules = [
          ./configuration.nix
        ];
      };
    };
}
