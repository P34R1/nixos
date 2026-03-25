{ self, inputs, ... }:

{
  flake.nixosModules.darkmodeBundle =
    { config, pkgs, ... }:
    {
      hm = {
        dconf.settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
        };

        gtk = {
          enable = true;
          theme = {
            name = "Adwaita-dark";
            package = pkgs.gnome-themes-extra;
          };

          gtk4.theme = null;
        };

        # Wayland, X, etc. support for session vars
        systemd.user.sessionVariables = config.hm.home.sessionVariables;
      };

      qt = {
        enable = true;
        platformTheme = "gnome";
        style = "adwaita-dark";
      };
    };
}
