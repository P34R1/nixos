{ self, inputs, ... }:

{
  flake.nixosModules.nginxDashy =
    { config, pkgs, ... }:
    let
      section = name: items: {
        name = name;
        items = items;
      };

      widget = name: type: options: {
        name = name;
        widgets = [
          {
            type = type;
            options = options;
          }
        ];
      };

      item = title: icon: url: {
        title = title;
        icon = icon;
        url = url;
      };

      nav = title: path: {
        title = title;
        path = path;
      };

      # https://dashboardicons.com/icons
      dash-icon = name: "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/${name}.svg";

      # https://dashy.to/docs/configuring/
      settings = {
        appConfig = {
          theme = "dashy-docs";
          preventWriteToDisk = true;
          preventLocalSave = true;
          disableConfiguration = false;
          hideComponents = {
            hideSearch = true;
            hideSettings = true;
            hideFooter = true;
          };
        };

        pageInfo = {
          title = "smegmail";
          navLinks = [
            (nav "Home" "/")
            (nav "Source" "https://github.com/P34R1/nixos/blob/main/modules/features/server/nginx/dashy.nix")
          ];
        };

        sections = [
          (section "Services" [
            (item "Nextcloud" (dash-icon "nextcloud") "https://cloud.smegmail.org/")
            (item "slskd" (dash-icon "slskd") "/slskd/")
            (item "Mail" (dash-icon "gmail") "https://mail.google.com/mail/u/2/")
          ])

          (section "Hosting" [
            (item "Gateway" "fas fa-wifi" "https://10.0.0.1/")
            (item "Cloudflare" (dash-icon "cloudflare") "https://dash.cloudflare.com/")
            (item "Tailscale" (dash-icon "tailscale") "https://login.tailscale.com/admin")
          ])

          (section "External" [
            (item "Github" "fab fa-github" "https://github.com/P34R1/")
          ])
        ];
      };
    in
    {
      # uncomment to avoid recompilation
      # services.nginx.virtualHosts.${config.services.dashy.virtualHost.domain}.locations."= /conf.yml".alias =
      #   pkgs.writers.writeYAML "dashy-conf.yml" settings;

      services.dashy = {
        enable = true;
        virtualHost = {
          enableNginx = true;
          domain = "www.${config.nginx.domain}";
        };

        settings = settings;
      };
    };
}
