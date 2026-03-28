{ self, inputs, ... }:

{
  flake.nixosModules.desktopBundle =
    { pkgs, ... }:
    {
      imports = with self.nixosModules; [
        alacritty
        tmux
        fish
        git
        fzf
        zen
        btop
        mpd
        yazi

        darkmode
        loginScreen
        volume
        networkManager
        flatpak
      ];

      nixpkgs.config.allowUnfree = true;
      environment.systemPackages = with pkgs; [
        bat
        eza # ls
        jq # json
        ripgrep
        fd

        trashy
        tlrc
        entr
        udisks2 # mounting
        udiskie

        cliphist
      ];

      # mounting
      services.udisks2.enable = true;
      services.gvfs.enable = true;

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
      programs.dconf.enable = true;
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
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

      hardware.acpilight.enable = true;
    };
}
