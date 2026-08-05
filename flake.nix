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

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      nix-homebrew,
      home-manager,
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

          nix-homebrew.darwinModules.nix-homebrew

          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              extraSpecialArgs = {
                inherit user;
              };

              users.${user} = import ./home.nix;
            };
          }
        ];
      };
    };
}
