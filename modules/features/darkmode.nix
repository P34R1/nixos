{ self, inputs, ... }:

{
  flake.nixosModules.darkmode =
    { config, pkgs, ... }:
    {
      programs.dconf.profiles.user.databases = [
        {
          lockAll = true; # prevents overriding
          settings = {
            "org/gnome/desktop/interface" = {
              color-scheme = "prefer-dark";
              gtk-theme = "adw-gtk3-dark";
            };
          };
        }
      ];

      qt = {
        enable = true;
        platformTheme = "gnome";
        style = "adwaita-dark";
      };

      environment.systemPackages = with pkgs; [
        adw-gtk3
      ];
    };
}
