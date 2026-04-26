{ self, inputs, ... }:

{
  flake.nixosConfigurations.pearl-server = inputs.nixpkgs.lib.nixosSystem {
    modules =
      with self.nixosModules;
      with inputs.nixos-hardware.nixosModules;
      [
        serverConfiguration
        serverHardware
      ];
  };

  flake.nixosModules.serverConfiguration =
    {
      pkgs,
      lib,
      config,
      ...
    }:

    {
      imports = with self.nixosModules; [
        coreBundle

        nginx
        slskd
        openssh
      ];

      git = {
        userEmail = "vincent.fortin279@gmail.com";
        userName = "pearl";
        signingKey = "8B38E4897208273A";
      };

      network = {
        hostName = "pearl-server";
        users = [ "pearl" ];
      };

      slskd.user = "pearl";
      openssh.user = "pearl";
      nix.flakePath = "/home/pearl/nixos/";

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.pearl = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      };

      # autostart fish
      programs.bash.loginShellInit = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]] then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec fish $LOGIN_OPTION
        fi
      '';

      # Bootloader.
      boot.loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot = {
          enable = true;
          configurationLimit = 10;
        };
      };

      system.stateVersion = "25.11"; # Don't change for simplicity!
    };
}
