{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  options = {
    keyd.enable = lib.mkEnableOption "enables keyd";
  };

  config = lib.mkIf config.keyd.enable {
    users.users.${config.user}.extraGroups = [ "keyd" ];

    # https://wiki.nixos.org/wiki/Keyd
    services.keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = [ "*" ];

          settings = {
            main.capslock = "overload(control, esc)";
          };
        };
      };
    };
  };
}
