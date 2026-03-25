{ self, inputs, ... }:

{
  flake.nixosConfigurations.pearl-laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.laptopConfiguration
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
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
    #     volume = import ../scripts/volume.nix { inherit pkgs; };
    #     toficlip = import ../scripts/tofi-clip.nix { inherit pkgs; };
    # in
    {
      imports = [
        self.nixosModules.laptopHardware

        self.nixosModules.keyd
        self.nixosModules.hmSetup

        self.nixosModules.desktopBundle
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
      };

      networkManager = {
        hostName = "pearl-laptop";
        users = [ "pearl" ];
      };

      tmux.reposPath = "~/repos/";

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
        just
        wl-clipboard
        chafa # terminal imgs
        playerctl
        glow # markdown parser

        nvim-pkg

        (discord.override {
          # withOpenASAR = true;
          withVencord = true;
        })

        # My Scripts
        # screenshot
        # volume
        # toficlip
      ];

      services.flatpak.packages = [
        # "dev.vencord.Vesktop"
        "com.obsproject.Studio"
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

      # Some programs need SUID wrappers, can be configured further or are
      # started in user sessions
      # programs.mtr.enable = true;

      # List services that you want to enable:

      # Enable the OpenSSH daemon.
      # services.openssh.enable = true;

      # Open ports in the firewall.
      # networking.firewall.allowedTCPPorts = [ ... ];
      # networking.firewall.allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      # networking.firewall.enable = false;

      security.pam.services.sudo.nodelay = true;

      system.stateVersion = "24.05"; # Don't change for simplicity!
    };
}
