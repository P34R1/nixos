{ self, inputs, ... }:

{
  flake.nixosModules.nvim =
    { pkgs, lib, ... }:
    {
      environment.systemPackages = with pkgs; [
        self.packages.${pkgs.stdenv.hostPlatform.system}.nvim
        glow # markdown parser
        nixfmt-tree
      ];
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.nvim = inputs.nvim.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
}
