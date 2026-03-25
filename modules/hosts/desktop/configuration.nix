{ self, inputs, ... }:

{
  flake.nixosConfigurations.pearl-desktop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.desktopConfiguration
      inputs.nixos-hardware.nixosModules.common-cpu-intel-skylake
      inputs.nixos-hardware.nixosModules.common-gpu-nvidia
      inputs.nixos-hardware.nixosModules.common-pc-ssd
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
      imports = [
        self.nixosModules.desktopHardware

        self.nixosModules.hmSetup

        self.nixosModules.desktopBundle
        self.nixosModules.nvidiaBundle
        self.nixosModules.gamingBundle
        self.nixosModules.darkmodeBundle

        inputs.nix-index-database.nixosModules.nix-index
      ];

      nixpkgs = {
        overlays = [
          inputs.nvim.overlays.default
        ];
      };

      loginScreen = {
        autoLogin = true;
        user = "pearl";
      };

      git = {
        userEmail = "undeadgamer279@gmail.com";
        userName = "pearl";
        signingKey = "D4F0D505725B265F";
      };

      hmSetup = {
        user = "pearl";
      };

      networkManager = {
        hostName = "pearl-desktop";
        users = [ "pearl" ];
      };

      tmux.reposPath = "/home/pearl/repos/";

      # razer.enable = true;

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
        htop

        just
        wl-clipboard
        chafa # terminal imgs
        playerctl
        glow # markdown parser

        nvim-pkg

        # blender # was using flatpak, needed to downgrade
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
        # "org.blender.Blender"
      ];

      # Bootloader.
      boot.loader.grub = {
        enable = true;
        useOSProber = true;
        copyKernels = true;
        efiSupport = true;
        devices = [ "nodev" ];
      };

      boot.loader.efi.efiSysMountPoint = "/boot/efi";
      boot.loader.efi.canTouchEfiVariables = true;

      security.pam.services = {
        sudo.nodelay = true;
        hyprlock.nodelay = true;
      };

      system.stateVersion = "24.05"; # Don't change for simplicity!
    };
}
