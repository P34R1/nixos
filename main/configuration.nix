# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

let
  screenshot = import ../scripts/screenshot.nix { inherit pkgs; };
  volume = import ../scripts/volume.nix { inherit pkgs; };
  toficlip = import ../scripts/tofi-clip.nix { inherit pkgs; };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # dwm
#      ./dwm.nix

      # Hypr
      ./hyprland.nix

      # Desktop
      ./desktop.nix
      ./darkmode.nix

      # Flatpak
      ./flatpak.nix

      # Home-Manager
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
    extraGroups = [ "networkmanager" "wheel" "openrazer" "audio" ];
    packages = with pkgs; [];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable networking
  networking = {
    hostName = "pearl-nix";
    enableIPv6 = false;
    networkmanager.enable = true;
  };

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
  security.pam.services.hyprlock = {};

  home-manager = {
    # Also pass inputs to home manager modules
    extraSpecialArgs = { inherit inputs; };
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    users.pearl = import ./home.nix;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    librewolf
    htop

    tlrc # tldr
    entr
    wl-clipboard
    chafa # terminal imgs
    playerctl
    openrazer-daemon
    udisks2 # auto mounting
    udiskie

    # My Scripts
    screenshot
    volume
    toficlip
  ];

  # https://github.com/ryanoasis/nerd-fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "RobotoMono" "JetBrainsMono" ]; })
    maple-mono
  ];

  services.udisks2.enable = true;

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
