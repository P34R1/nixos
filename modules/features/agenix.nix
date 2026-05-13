{ self, inputs, ... }:

{
  flake.nixosModules.agenix =
    { pkgs, ... }:
    let
      inherit (inputs) agenix;
    in
    {
      imports = [
        agenix.nixosModules.default
      ];

      age.identityPaths = [ "/home/pearl/.ssh/id_ed25519" ];

      environment.systemPackages = [
        agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
}
