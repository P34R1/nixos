{ config, pkgs, lib, inputs, ... }:

{
  options = {
    spicetify.enable =
      lib.mkEnableOption "enable spicetify";
  };

  config = lib.mkIf config.spicetify.enable {

    # https://github.com/Gerg-L/spicetify-nix
    hm.programs.spicetify = let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        shuffle # shuffle+ (special characters are sanitized out of extension names)
        betterGenres
      ];
      theme = spicePkgs.themes.blossom;
      # colorScheme = "mocha";
    };
  };
}
