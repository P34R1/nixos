{ self, inputs, ... }:

{
  flake.nixosModules.network =
    {
      config,
      pkgs,
      lib,
      ...
    }:

    let
      cfg = config.network;

      fw = config.networking.firewall;
      TCPPorts = lib.concatMapStringsSep " " (n: "${toString n} TCP") fw.allowedTCPPorts;
      UDPPorts = lib.concatMapStringsSep " " (n: "${toString n} UDP") fw.allowedUDPPorts;
    in
    {
      options.network = with lib; {
        hostName = mkOption { type = types.str; };
        users = mkOption { type = types.listOf types.str; };
        enableUpnp = mkOption { type = types.bool; default = false; };
      };

      config = {
        networking = {
          hostName = cfg.hostName;
          networkmanager.enable = true;
          nftables.enable = true;
        };

        users.users = lib.genAttrs cfg.users (user: {
          extraGroups = [ "networkmanager" ];
        });

        environment.systemPackages = lib.mkIf cfg.enableUpnp [ pkgs.miniupnpc ];
        systemd.services."upnp-port-forward" = lib.mkIf cfg.enableUpnp {
          after = [ "network.target" ];
          serviceConfig.Type = "oneshot";
          script = "${pkgs.miniupnpc}/bin/upnpc -r ${TCPPorts} ${UDPPorts}";
        };

        systemd.timers."upnp-port-forward" = lib.mkIf cfg.enableUpnp {
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnBootSec = "2min";
            OnUnitActiveSec = "1h";
            Unit = "upnp-port-forward.service";
          };
        };
      };
    };
}
