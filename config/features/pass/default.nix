{
  config,
  pkgs,
  lib,
  ...
}:

let
  passScripts = import ./scripts.nix {
    inherit pkgs;
    inherit lib;
    inherit config;
  };
in
{
  options = {
    pass.enable = lib.mkEnableOption "enable gnu pass";
  };

  config = lib.mkIf config.pass.enable {

    # https://search.nixos.org/options?channel=unstable&show=programs.gnupg.agent.enable&from=0&size=50&sort=relevance&type=packages&query=programs.gnupg
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-gtk2; # https://discourse.nixos.org/t/cant-get-gnupg-to-work-no-pinentry/15373/4
    };

    # Overlay to disable everything
    # Needed to remove extra pkgs and passmenu 🤢
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/security/pass/default.nix#L6
    # idk why but it needs to be an overlay, not a pkg override
    nixpkgs.overlays = [
      (self: super: {
        pass = super.pass.override {
          xclip = null;
          xdotool = null;
          dmenu = null;
          x11Support = false;
          dmenuSupport = false;
          waylandSupport = false;
          wl-clipboard = null;
          ydotool = null;
          dmenu-wayland = null;
        };
      })
    ];

    environment.systemPackages = [
      pkgs.pass
      pkgs.pinentry-gtk2

      passScripts
    ];
  };
}
