{ self, inputs, ... }:

{
  flake.nixosModules.nix =
    {
      config,
      pkgs,
      lib,
      ...
    }:

    let
      cfg = config.nix;
    in
    {
      options.nix = with lib; {
        flakePath = mkOption { type = types.str; };
      };

      config = {
        nixpkgs = {
          config.allowUnfree = true;

          # use lix
          overlays = [
            (final: prev: {
              inherit (prev.lixPackageSets.stable)
                nixpkgs-review
                nix-eval-jobs
                nix-fast-build
                colmena
                ;
            })
          ];
        };

        nix = {
          package = pkgs.lixPackageSets.stable.lix;
          settings.experimental-features = [
            "nix-command"
            "flakes"
          ];
        };

        programs.nh = {
          enable = true;
          flake = cfg.flakePath;
          clean.enable = true;
          clean.extraArgs = "--keep-since 4d --keep 3";
        };
      };
    };
}
