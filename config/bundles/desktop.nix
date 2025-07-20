{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.desktop;

  inherit (lib.strings)
    concatMapStrings
    concatMapStringsSep
    optionalString
    ;

  wms = [
    {
      name = "hyprland";
      command = "Hyprland";
      indicator = "h";
      enable = config.hyprland.enable;
    }
    {
      name = "dwm";
      command = "sx dwm";
      indicator = "d";
      enable = config.dwm.enable;
    }
  ];

  # \033[1m => bold        \033[0m => unbold
  # https://ryantm.github.io/nixpkgs/functions/library/strings/#function-library-lib.strings.concatMapStrings
  enabledOptions = concatMapStrings (
    opt: optionalString opt.enable "\\033[1m[${opt.indicator}]\\033[0m - ${opt.name}\\n"
  ) wms;

  # https://ryantm.github.io/nixpkgs/functions/library/strings/#function-library-lib.strings.concatMapStringsSep
  enabledCases = concatMapStringsSep "\n" (
    opt: optionalString opt.enable "${opt.indicator}) exec ${opt.command};;"
  ) wms;
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
    dwm.enable = lib.mkDefault true;

    git.enable = lib.mkDefault true;
    lazygit.enable = lib.mkDefault true;
    fish.enable = lib.mkDefault true;
    tmux.enable = lib.mkDefault true;

    hm.programs = {

      fd.enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fd.enable
      fd.ignores = [ ".git/" ];

      bat.enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bat.enable
      eza.enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.eza.enable
      jq.enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.jq.enable
      ripgrep.enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ripgrep.enable

      fzf = {
        enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.enable
        defaultCommand = "fd --color=always";

        # https://github.com/PatrickF1/fzf.fish/blob/main/functions/_fzf_wrapper.fish
        defaultOptions = [
          "--cycle" # allows jumping between the first and last results, making scrolling faster
          "--layout=reverse" # lists results top to bottom, mimicking the familiar layouts of git log, history, and env
          "--border" # shows where the fzf window begins and ends
          "--height=90%" # leaves space to see the current command and some scrollback, maintaining context of work
          "--preview-window=wrap" # wraps long lines in the preview window, making reading easier
          "--marker=\"*\"" # makes the multi-select marker more distinguishable from the pointer (since both default to >)
          "--ansi" # enable ansi color code parsing
        ];
      };
    };

    hm.services.cliphist = {
      enable = true;
      allowImages = true;
    };

    hm.home.sessionVariables = {
      VISUAL = "nvim";
      EDITOR = "nvim";
    };

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
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.roboto-mono
      nerd-fonts.jetbrains-mono
      maple-mono.truetype
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

    # https://wiki.archlinux.org/title/Xinit#Autostart_X_at_login
    hm.home.file.".bash_profile".text = ''
      if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
        printf "${enabledOptions}"

        stty -icanon -echo
        choice=$(dd bs=1 count=1 2>/dev/null)
        stty icanon echo

        case "$choice" in
          ${enabledCases}
        esac
      fi
    '';

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
