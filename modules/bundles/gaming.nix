{ self, inputs, ... }:

{
  flake.nixosModules.gamingBundle =
    { pkgs, ... }:
    {
      environment = {
        systemPackages = with pkgs; [
          mangohud
          protonup-ng
        ];

        sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
      };

      programs.gamemode.enable = true;
      programs.steam = {
        enable = true;
        gamescopeSession.enable = true;
        localNetworkGameTransfers.openFirewall = true;
      };

      boot.kernelModules = [ "ntsync" ];
    };
}
