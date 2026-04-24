{ self, inputs, ... }:

{
  flake.nixosModules.coreBundle =
    { pkgs, ... }:
    {
      imports = with self.nixosModules; [
        git
        nvim
        fish
        btop

        nix
        network
      ];

      nixpkgs.config.allowUnfree = true;
      environment.systemPackages = with pkgs; [
        trashy
        tlrc
        udisks2 # mounting
        udiskie
      ];

      # mounting
      services.udisks2.enable = true;
      services.gvfs.enable = true;

      environment.variables = {
        VISUAL = "nvim";
        EDITOR = "nvim";
      };

      time.timeZone = "America/Toronto";
      i18n.defaultLocale = "en_CA.UTF-8";

      # Configure keymap in X11
      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };
    };
}
