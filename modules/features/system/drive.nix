{ self, inputs, ... }:

{
  flake.nixosModules.drive =
    { pkgs, lib, ... }:
    {
      # mounting
      security.polkit = {
        enable = true;
        extraConfig = ''
          polkit.addRule(function (action, subject) {
            const udisks = action.id.indexOf("org.freedesktop.udisks2.") === 0;
            const login1 = action.id.indexOf("org.freedesktop.login1.") === 0;

            if (subject.isInGroup("wheel") && (udisks || login1)) {
              return polkit.Result.YES;
            }
          });
        '';
      };

      services = {
        udisks2.enable = true;
        gvfs.enable = true;
      };

      systemd.user.services.udiskie = {
        description = "Udiskie Automount Daemon";
        wantedBy = [ "default.target" ];

        serviceConfig = {
          ExecStart = "${lib.getExe' pkgs.udiskie "udiskie"} -anTF";
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
