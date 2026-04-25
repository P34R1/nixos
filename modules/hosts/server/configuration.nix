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
      tmux.enable = false;
      nix.flakePath = "/home/pearl/nixos/";

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.pearl = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH97h8jvSFDbZPR4/KKhAUf8mtrgeIqWGzB9S0ATunDs undeadgamer279@gmail.com"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPCAtzH4xk6DyVHj61pl4VzLS2uFaG8s45Xr6u0uX2MA undeadgamer279@gmail.com"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICvavh5rpoj12Ywi5lXT6hCn38KZuZaU8Ln5Rh3OxsPb vincent.fortin279@gmail.com"
        ];
      };

      # autostart fish
      programs.bash = {
        loginShellInit = ''
          if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]] then
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
            exec fish $LOGIN_OPTION
          fi
        '';
      };

      services = {
        openssh = {
          enable = true;
          listenAddresses = [
            {
              addr = "0.0.0.0";
              port = 22;
            }
            {
              addr = "[::]";
              port = 22;
            }
          ];

          settings = {
            PasswordAuthentication = false;
            AllowUsers = [ "pearl" ];
            PermitRootLogin = "no";
          };
        };
      };

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
