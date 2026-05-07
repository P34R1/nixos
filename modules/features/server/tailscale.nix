{ self, inputs, ... }:

{
  flake.nixosModules.tailscale =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.tailscale;
      vpnScript = pkgs.writeShellScriptBin "vpn" ''
        case "$1" in
          on)
            echo "Enabling exit node..."
            tailscale set --exit-node server
            ;;
          off)
            echo "Disabling exit node..."
            tailscale set --exit-node ""
            ;;
          *)
            echo "Usage: $0 on|off"
            exit 1
            ;;
        esac

        echo "status:"
        tailscale status
      '';
    in
    {
      options.tailscale.server = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };

      config = {
        # https://wiki.nixos.org/wiki/Tailscale
        services.tailscale = {
          enable = true;
          openFirewall = true;

          useRoutingFeatures = if cfg.server then "server" else "client";
          extraUpFlags = lib.mkIf cfg.server [ "--advertise-exit-node" ];
        };

        networking.firewall.trustedInterfaces = [ config.services.tailscale.interfaceName ];

        # Force tailscaled to use nftables (Critical for clean nftables-only systems)
        systemd.services.tailscaled.serviceConfig.Environment = [
          "TS_DEBUG_FIREWALL_MODE=nftables"
        ];

        # Prevent systemd from waiting for network online
        systemd.network.wait-online.enable = false;
        boot.initrd.systemd.network.wait-online.enable = false;

        # optimize UDP throughput
        environment.systemPackages = if cfg.server then [ pkgs.ethtool ] else [ vpnScript ];
        services.networkd-dispatcher = lib.mkIf cfg.server {
          enable = true;
          rules."50-tailscale-optimizations" = {
            onState = [ "routable" ];
            script = ''
              ${pkgs.ethtool}/bin/ethtool -K enp4s0 rx-udp-gro-forwarding on rx-gro-list off
            '';
          };
        };
      };
    };
}
