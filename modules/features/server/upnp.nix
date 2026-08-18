{ self, inputs, ... }:

{
  flake.nixosModules.auto-upnp =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      fw = config.networking.firewall;
      TCPPorts = lib.concatMapStringsSep " " (n: "${toString n} TCP") fw.allowedTCPPorts;
      UDPPorts = lib.concatMapStringsSep " " (n: "${toString n} UDP") fw.allowedUDPPorts;
    in
    {
      systemd.services."upnp-port-forward" = {
        after = [ "network.target" ];
        serviceConfig.Type = "oneshot";
        script = "${pkgs.miniupnpc}/bin/upnpc -r ${TCPPorts} ${UDPPorts}";
      };

      systemd.timers."upnp-port-forward" = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnBootSec = "2min";
          OnUnitActiveSec = "1h";
          Unit = "upnp-port-forward.service";
        };
      };
    };
}
