# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

let
  screenshot = import ../scripts/screenshot.nix { inherit pkgs; };
  volume = import ../scripts/volume.nix { inherit pkgs; };
  toficlip = import ../scripts/tofi-clip.nix { inherit pkgs; };
  trashput = import ../scripts/trash-put.nix { inherit pkgs; };
  tmuxdrv = import ../scripts/tmux/default.nix { inherit pkgs; repoPaths = "~/repos"; };
  projectdo = import ../scripts/projectdo/default.nix { inherit pkgs; };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # dwm
      # ./dwm.nix

      # Hypr
      #../config/hypr/hyprland.nix

      ../config

      # Desktop
      ./desktop.nix
      ./darkmode.nix

      # Flatpak
      ./flatpak.nix

      # Home-Manager
      inputs.home-manager.nixosModules.default
    ];

  user = "pearl"; # set default user here

  git.enable = true;
  lazygit.enable = true;
  nnn.enable = false;
  foot.enable = true;
  hyprland.enable = true;
  tofi.enable = true;
  yazi.enable = true;
  spicetify.enable = true;
  dunst.enable = true;
  fish.enable = true;

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
  users.users.${config.user} = {
    isNormalUser = true;
    description = "Vincent Fortin";
    extraGroups = [ "networkmanager" "wheel" "openrazer" "audio" ];
    packages = with pkgs; [];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/${config.user}/nixos";
  };

  # Enable networking
  networking = {
    hostName = "vincent-desktop";
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
  services.getty.autologinUser = "${config.user}";
  security.pam.services.hyprlock = {};
  security.pam.services.hyprlock.nodelay = true;
  security.pam.services.sudo.nodelay = true;

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

    trashy # trash-cli replacment
    tlrc # tldr
    entr
    wl-clipboard
    chafa # terminal imgs
    playerctl
    openrazer-daemon
    udisks2 # auto mounting
    udiskie
    glow # markdown parser

    # My Scripts
    screenshot
    volume
    toficlip
    trashput
    tmuxdrv
    projectdo
  ];

  # https://github.com/ryanoasis/nerd-fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "RobotoMono" "JetBrainsMono" ]; })
    maple-mono
  ];

  services.udisks2.enable = true;
  services.gvfs.enable = true;

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
