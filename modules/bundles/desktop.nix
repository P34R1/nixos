{ self, inputs, ... }:

{
  flake.nixosModules.desktopBundle =
    { pkgs, ... }:
    {
      imports = with self.nixosModules; [
        coreBundle
        zen
        mpd
        keyd

        darkmode
        loginScreen
        audio
        brightness
        flatpak
      ];

      environment.systemPackages = with pkgs; [
        cliphist
      ];

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
