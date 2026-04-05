{ self, inputs, ... }:

{
  flake.nixosModules.desktopBundle =
    { pkgs, ... }:
    {
      imports = with self.nixosModules; [
        git
        nvim
        fish

        zen
        btop
        mpd
        keyd

        nix
        hmSetup
        darkmode
        loginScreen
        audio
        brightness
        network
        flatpak
      ];

      nixpkgs.config.allowUnfree = true;
      environment.systemPackages = with pkgs; [
        trashy
        tlrc
        udisks2 # mounting
        udiskie

        cliphist
      ];

      # mounting
      services.udisks2.enable = true;
      services.gvfs.enable = true;

      hm.home.sessionVariables = {
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

      # https://github.com/ryanoasis/nerd-fonts
      fonts.packages = with pkgs; [
        nerd-fonts.fira-code
        nerd-fonts.droid-sans-mono
        nerd-fonts.roboto-mono
        nerd-fonts.jetbrains-mono
        maple-mono.truetype
        corefonts
      ];

      # Graphics
      programs.dconf.enable = true;
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
}
