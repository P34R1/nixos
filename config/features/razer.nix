{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    razer.enable = lib.mkEnableOption "enable razer";
  };

  config = lib.mkIf config.razer.enable {

    # https://nixos.wiki/wiki/Hardware/Razer
    hardware.openrazer.enable = lib.mkDefault true;
    environment.systemPackages = with pkgs; [
      openrazer-daemon
      polychromatic
    ];

    users.users.${config.user}.extraGroups = [ "openrazer" ];
  };
}
