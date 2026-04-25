{ self, inputs, ... }:

{
  flake.nixosConfigurations.pearl-server = inputs.nixpkgs.lib.nixosSystem {
    modules =
      with self.nixosModules;
      with inputs.nixos-hardware.nixosModules;
      [
        serverConfiguration
        serverHardware
        # lenovo-thinkpad-t480
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

      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          AllowUsers = [ "pearl" ];
          PermitRootLogin = "no";
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
