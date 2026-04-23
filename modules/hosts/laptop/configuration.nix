{ self, inputs, ... }:

{
  flake.nixosConfigurations.pearl-laptop = inputs.nixpkgs.lib.nixosSystem {
    modules =
      with self.nixosModules;
      with inputs.nixos-hardware.nixosModules;
      [
        laptopConfiguration
        laptopHardware
        lenovo-thinkpad-t480
      ];
  };

  flake.nixosModules.laptopConfiguration =
    {
      pkgs,
      lib,
      config,
      ...
    }:

    {
      imports = with self.nixosModules; [
        bluetooth
        hyprland
        dwm

        desktopBundle
        gamingBundle
      ];

      loginScreen = {
        autoLogin = false;
        user = "pearl";
      };

      git = {
        userEmail = "vincent.fortin279@gmail.com";
        userName = "pearl";
        signingKey = "940A57535F901655";
      };

      keyd = {
        users = [ "pearl" ];
        settings = {
          capslock = "leftmeta";
          leftmeta = "capslock";

          switchvideomode = "previoussong";
          wlan = "playpause";
          config = "nextsong";
        };
      };

      mpd.user = "pearl";
      audio.users = [ "pearl" ];
      brightness.users = [ "pearl" ];
      network = {
        hostName = "pearl-laptop";
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

      # List packages installed in system profile. To search, run:
      # $ nix search wget
      environment.systemPackages = with pkgs; [
        (discord.override {
          # withOpenASAR = true;
          withVencord = true;
        })
      ];

      services.flatpak.packages = [
        # "dev.vencord.Vesktop"
        "com.obsproject.Studio"
      ];

      # Bootloader.
      boot.loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot = {
          enable = true;
          configurationLimit = 10;
        };
      };

      security.pam.services.sudo.nodelay = true;
      system.stateVersion = "24.05"; # Don't change for simplicity!
    };
}
