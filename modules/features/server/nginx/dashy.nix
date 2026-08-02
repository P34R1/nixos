{ self, inputs, ... }:

{
  flake.nixosModules.nginxDashy =
    { config, pkgs, ... }:
    let
      section = name: displayData: type: items: {
        name = name;
        displayData = displayData;
        ${type} = items;
      };

      widget = type: options: {
        type = type;
        options = options;
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
          disableConfiguration = true;

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
          (section "Services" { } "items" [
            (item "Nextcloud" (dash-icon "nextcloud") "https://cloud.${config.nginx.domain}/")
            (item "slskd" (dash-icon "slskd") "/slskd/")
            (item "Mail" (dash-icon "gmail") "https://mail.google.com/mail/u/2/")
          ])

          (section "Hosting" { } "items" [
            (item "Gateway" "fas fa-wifi" "https://10.0.0.1/")
            (item "Cloudflare" (dash-icon "cloudflare") "https://dash.cloudflare.com/")
            (item "Tailscale" (dash-icon "tailscale") "https://login.tailscale.com/admin/")
            (item "AirVPN" (dash-icon "airvpn") "https://airvpn.org/client/")
          ])

          (section "External" { } "items" [
            (item "Github" "fab fa-github" "https://github.com/P34R1/")
          ])

          (section "Glances" { } "widgets" [
            (widget "gl-mem-history" {
              hostname = "https://${config.services.dashy.virtualHost.domain}/glances";
            })
            (widget "gl-disk-space" {
              hostname = "https://${config.services.dashy.virtualHost.domain}/glances";
            })
          ])

          (section "Weather Forecast" { cols = 2; } "widgets" [
            (widget "iframe" {
              url = "https://wttr.in/?qF";
              frameHeight = 604;
            })
          ])
        ];
      };
    in
    {
      services.nginx.virtualHosts.${config.services.dashy.virtualHost.domain}.locations = {
        # uncomment to avoid recompilation
        # "= /conf.yml".alias = pkgs.writers.writeYAML "dashy-conf.yml" settings;
        "/glances/".proxyPass = "http://127.0.0.1:${toString config.services.glances.port}";
      };

      services.glances.enable = true;
      services.dashy = {
        enable = true;
        virtualHost = {
          enableNginx = true;
          domain = "www.${config.nginx.domain}";
        };

        settings = settings;
      };

      environment.etc."glances/glances.conf".text = ''
        [outputs]
        cors_origins=https://www.${config.nginx.domain}
        url_prefix=/glances/

        [fs]
        hide=/boot.*,/var.*,/tmp,/nix/store
      '';
    };
}
