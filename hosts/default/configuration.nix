# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pearl = {
    isNormalUser = true;
    description = "Vincent Fortin";
    extraGroups = [ "networkmanager" "wheel" "openrazer" ];
    #shell = pkgs.zsh;
    packages = with pkgs; [];
  };

  networking.hostName = "pearl-nix"; # Define your hostname.

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "pearl";

  home-manager = {
    # Also pass inputs to home manager modules
    extraSpecialArgs = { inherit inputs; };
    users = {
      "pearl" = import ./home.nix;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Graphics
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
  };

  services.xserver.windowManager.dwm.enable = true;
  services.xserver.enable = true;
  services.xserver.autorun = false;
  services.xserver.displayManager.startx.enable = true;

  services.xserver.windowManager.dwm.package = pkgs.dwm.override {
    patches = [
      # replace hash with the value from `nix-prefetch-url "https://dwm.suckless.org/patches/path/to/patch.diff" | xargs nix hash to-sri --type sha256`
      (pkgs.fetchpatch {
        url = "https://dwm.suckless.org/patches/fullgaps/dwm-fullgaps-20200508-7b77734.diff";
        hash = "sha256-+b88csCfyR8cnn95rz6enLELLCoHl00gdBhS1Q/mw3o=";
      })

      (pkgs.fetchpatch {
        url = "https://dwm.suckless.org/patches/steam/dwm-steam-6.2.diff";
        hash = "sha256-Lvgyv+h1nMdx+Hnw/r1S2Ubd1eh2fmHyQ65cA934odE=";
      })
    ];
  }; 

  #services.xserver.windowManager.dwm.package = pkgs.dwm.overrideAttrs {
  #  src = /home/pearl/dwm;
  #}; 

#  programs.hyprland = {
#    enable = true;
#    xwayland.enable = true;
#  };
#  environment.sessionVariables.NIXOS_OZONE_NL = "1";
#  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
#  xdg.portal.enable = true;
#  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Enable Sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };  


  hardware.openrazer.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git  
    wget
    swww
    rofi-wayland
    librewolf
    pkgs.kitty
    pkgs.waybar
    openrazer-daemon

    git-credential-oauth

    dmenu

    font-awesome # FIX (doesn't fix waybar for wtv reason)

    libnotify
 #   pkgs.emptty
 #   pkgs.lemurs
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "24.05"; # Don't change for simplicity!
}
