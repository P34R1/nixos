{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.desktop;
in
{
  options = {
    desktop = {
      enable = lib.mkEnableOption "enable default desktop configuration";

      nvidia = lib.mkOption {
        type = lib.types.bool;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    hyprland.enable = lib.mkDefault true;

    git.enable = lib.mkDefault true;
    lazygit.enable = lib.mkDefault true;
    fish.enable = lib.mkDefault true;
    tmux.enable = lib.mkDefault true;

    time.timeZone = "America/Toronto";
    i18n.defaultLocale = "en_CA.UTF-8";

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # https://github.com/ryanoasis/nerd-fonts
    fonts.packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "DroidSansMono"
          "RobotoMono"
          "JetBrainsMono"
        ];
      })
      maple-mono
      corefonts
    ];

    # Graphics
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    services.xserver.videoDrivers = lib.mkIf cfg.nvidia [ "nvidia" ];
    programs.gamemode.enable = true;

    hardware.nvidia = lib.mkIf cfg.nvidia {
      modesetting.enable = true; # Modesetting is required.

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = false;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    # Enable Sound
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # Enable Razer
    hardware.openrazer.enable = true;

    # DARKMODE
    hm = {
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };

      gtk = {
        enable = true;
        theme = {
          name = "Adwaita-dark";
          package = pkgs.gnome-themes-extra;
        };
      };

      # Wayland, X, etc. support for session vars
      systemd.user.sessionVariables = config.hm.home.sessionVariables;
    };

    qt = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };
  };
}
