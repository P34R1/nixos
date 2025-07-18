# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

let
  screenshot = import ../scripts/screenshot.nix { inherit pkgs; };
  volume = import ../scripts/volume.nix { inherit pkgs; };
  toficlip = import ../scripts/tofi-clip.nix { inherit pkgs; };
  tmuxdrv = import ../scripts/tmux/default.nix {
    inherit pkgs;
    repoPaths = "~/repos";
  };
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Flatpak
    ./flatpak.nix
  ];

  nixpkgs = {
    overlays = [
      inputs.nvim.overlays.default
    ];
  };

  user = "pearl"; # set default user here
  git.userEmail = "vincent.fortin279@gmail.com";
  git.userName = "pearl";
  git.signingKey = "940A57535F901655";

  hyprland.enable = false;
  dwm.enable = true;
  librewolf.enable = true;
  keyd.enable = true;

  yazi.enable = true;
  spicetify.enable = false;
  fish.enable = true;
  tmux.enable = true;
  mpd.enable = true;
  pass.enable = true;

  desktop.enable = true;
  desktop.nvidia = false;

  programs.dconf.enable = true;
  programs.light.enable = true;

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
    extraGroups = [
      "networkmanager"
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
    flake = "${config.hm.home.homeDirectory}/nixos";
  };

  # Enable networking
  networking = {
    hostName = "pearl-laptop";
    enableIPv6 = false;
    networkmanager.enable = true;
  };

  # Enable username (only ask for password)
  services.getty.extraArgs = [
    "--skip-login"
    "--login-options"
    "${config.user}"
  ];
  services.getty.helpLine = lib.mkForce ""; # https://www.reddit.com/r/NixOS/comments/161uvb5/remove_nixoshelp_reminder_on_tty/
  security.pam.services.sudo.nodelay = true;

  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "backup";

    # Also pass inputs to home manager modules
    extraSpecialArgs = {
      inherit inputs;
    };
  };

  hm.home.file =
    let
      homeDir = config.hm.home.homeDirectory;
      link = config.hm.lib.file.mkOutOfStoreSymlink;
    in
    {
      ".local/share/colorscripts/".source = link "${homeDir}/repos/shell-color-scripts/colorscripts";
      ".local/share/wall.png".source = link "${homeDir}/backgrounds/nix-wallpaper-simple-blue.png";
    };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    htop

    trashy # trash-cli replacment
    tlrc # tldr
    entr
    just
    wl-clipboard
    chafa # terminal imgs
    playerctl
    udisks2 # auto mounting
    udiskie
    glow # markdown parser

    nvim-pkg

    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })

    # My Scripts
    screenshot
    volume
    toficlip
    tmuxdrv
  ];

  services.udisks2.enable = true;
  services.gvfs.enable = true;

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

  system.stateVersion = "24.05"; # Don't change for simplicity!
}
