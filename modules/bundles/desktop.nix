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
        flatpak

        darkmode
        loginScreen
        audio
        video
      ];

      environment.systemPackages = with pkgs; [
        cliphist
        (discord.override {
          # withOpenASAR = true;
          withVencord = true;
        })
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

    };
}
