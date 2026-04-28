{ self, inputs, ... }:

{
  flake.nixosModules.drive =
    { pkgs, lib, ... }:
    {
      # mounting
      services = {
        udisks2.enable = true;
        gvfs.enable = true;
      };

      environment.systemPackages = with pkgs; [
        udiskie

        (writeShellScriptBin "eject" ''
          selection=$(udiskie-info -aqo "{ui_label}" | grep -v "/dev/sda" | fzf -m --header="Select device(s) to eject (Tab to multi-select)") || exit 1
          devices=$(echo "$selection" | cut -d ':' -f 1)
          echo "Ejecting: $devices"
          udiskie-umount -ef $devices
        '')
      ];
    };
}
