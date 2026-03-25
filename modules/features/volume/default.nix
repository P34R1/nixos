{ self, inputs, ... }:

{
  flake.nixosModules.volume =
    { pkgs, lib, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.volume
      ];
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.volume = (
        pkgs.stdenv.mkDerivation {
          name = "volume-script";

          src = builtins.path { path = ./.; };
          buildInputs = with pkgs; [
            wireplumber
            dunst
          ];

          installPhase = ''
            mkdir -p $out/bin
            cp volume $out/bin
          '';

          meta = with pkgs.lib; {
            license = licenses.mit;
            platforms = platforms.linux;
          };
        }
      );
    };
}
