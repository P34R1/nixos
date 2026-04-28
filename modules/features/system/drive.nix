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

      systemd.user.services.udiskie = {
        description = "Udiskie Automount Daemon";
        wantedBy = [ "default.target" ];

        serviceConfig = {
          ExecStart = "${lib.getExe' pkgs.udiskie "udiskie"} -anT";
          Restart = "on-failure";
        };
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
