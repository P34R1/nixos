{ config, pkgs, inputs, ... }:

{
  # https://github.com/Gerg-L/spicetify-nix
  programs.spicetify = let
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
}
