{ self, inputs, ... }:

{
  flake.nixosModules.bluetooth =
    {
      config,
      pkgs,
      lib,
      ...
    }:

    {
      hardware.bluetooth = {
        enable = true;
        settings = { };
      };

      environment.systemPackages = with pkgs; [
        bluetui
      ];

      boot.kernelModules = [
        "bluetooth"
        "btusb"
      ];
    };
}
