{ self, inputs, ... }:

{
  flake.nixosConfigurations.pearl-desktop = inputs.nixpkgs.lib.nixosSystem {
    modules =
      with self.nixosModules;
      with inputs.nixos-hardware.nixosModules;
      [
        desktopConfiguration
        desktopHardware
        nvidia

        common-cpu-intel
        common-gpu-nvidia
        common-pc-ssd
      ];
  };

  flake.nixosModules.desktopConfiguration =
    {
      pkgs,
      lib,
      config,
      ...
    }:

    {
      imports = with self.nixosModules; [
        hyprland
        dwm

        desktopBundle
        gamingBundle
      ];

      loginScreen = {
        autoLogin = true;
        user = "pearl";
      };

      git = {
        userEmail = "undeadgamer279@gmail.com";
        userName = "pearl";
        signingKey = "D4F0D505725B265F";
      };

      keyd = {
        users = [ "pearl" ];
        settings = { };
      };

      mpd.user = "pearl";
      audio.users = [ "pearl" ];
      network = {
        hostName = "pearl-desktop";
        users = [ "pearl" ];
      };

      nix.flakePath = "/home/pearl/nixos/";
      tmux.reposPath = "/home/pearl/repos/";

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.pearl = {
        isNormalUser = true;
        description = "Vincent Fortin";
        uid = 1000;
        extraGroups = [ "wheel" ];
      };

      services.flatpak.packages = [
        # "dev.vencord.Vesktop"
        "com.obsproject.Studio"
        # "org.blender.Blender"
      ];

      # Bootloader.
      boot.loader = {
        efi = {
          efiSysMountPoint = "/boot/efi";
          canTouchEfiVariables = true;
        };

        grub = {
          enable = true;
          useOSProber = true;

          copyKernels = true;
          efiSupport = true;
          devices = [ "nodev" ];
        };
      };

      security.pam.services = {
        sudo.nodelay = true;
        hyprlock.nodelay = true;
      };

      system.stateVersion = "24.05"; # Don't change for simplicity!
    };
}
