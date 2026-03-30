{ self, inputs, ... }:

{
  flake.nixosConfigurations.pearl-laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.laptopConfiguration
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
      inputs.nix-index-database.nixosModules.nix-index
    ];
  };

  flake.nixosModules.laptopConfiguration =
    {
      pkgs,
      lib,
      config,
      ...
    }:

    # let
    #     screenshot = import ../scripts/screenshot.nix { inherit pkgs; };
    #     toficlip = import ../scripts/tofi-clip.nix { inherit pkgs; };
    # in
    {
      imports = with self.nixosModules; [
        laptopHardware
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

      hmSetup = {
        user = "pearl";
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

      audio.users = [ "pearl" ];
      network = {
        hostName = "pearl-laptop";
        users = [ "pearl" ];
      };

      tmux.reposPath = "/home/pearl/repos/";
      mpd.musicPath = "/home/pearl/Music/";

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.pearl = {
        isNormalUser = true;
        description = "Vincent Fortin";
        extraGroups = [
          "wheel"
          "audio"
          "video"
        ];
        packages = with pkgs; [ ];
      };

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 4d --keep 3";
        flake = "/home/pearl/nixos";
      };

      # List packages installed in system profile. To search, run:
      # $ nix search wget
      environment.systemPackages = with pkgs; [
        (discord.override {
          # withOpenASAR = true;
          withVencord = true;
        })

        # My Scripts
        # screenshot
        # toficlip
      ];

      services.flatpak.packages = [
        # "dev.vencord.Vesktop"
        "com.obsproject.Studio"
      ];

      # Bootloader.
      boot.loader = {
        efi = {
          efiSysMountPoint = "/boot/efi";
          canTouchEfiVariables = true;
        };

        grub = {
          enable = true;
          efiSupport = true;
          device = "nodev";
        };
      };

      security.pam.services.sudo.nodelay = true;
      system.stateVersion = "24.05"; # Don't change for simplicity!
    };
}
