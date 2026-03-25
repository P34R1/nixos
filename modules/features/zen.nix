{ self, inputs, ... }:

{
  flake.nixosModules.zen =
    { pkgs, ... }:
    {
      # https://wiki.nixos.org/wiki/Zen_Browser
      environment.systemPackages = [
        inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };

}
