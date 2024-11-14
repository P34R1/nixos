{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nvim.url = "github:P34R1/nvim";
    # dwm.url = "github:P34R1/dwm";
    # slstatus.url = "github:P34R1/slstatus";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak"; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    nix-colors.url = "github:misterio77/nix-colors";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      nixosConfigurations.vincent-desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./vincent-desktop/configuration.nix
          ./config
          inputs.nix-flatpak.nixosModules.nix-flatpak
          inputs.nix-index-database.nixosModules.nix-index
        ];
      };
      nixosConfigurations.pearl-laptop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./laptop/configuration.nix
          ./config
          inputs.nix-flatpak.nixosModules.nix-flatpak
        ];
      };
    };
}
