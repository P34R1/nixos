{ config, lib, ... }:

{
  options = {
    irssi.enable = lib.mkEnableOption "enables irssi";
  };

  config = lib.mkIf config.irssi.enable {
    hm.programs.irssi = {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.irssi.enable

      extraConfig = ''
        settings = {
          core = {
            real_name = "pearl";
          };

          "fe-common/core" = {
            autolog = "yes";
          };
        };
      '';

      networks = {
        liberachat = {
          nick = "pear1";
          saslExternal = true;

          server = {
            address = "irc.libera.chat";
            port = 6697;
            autoConnect = false;

            ssl.certificateFile = "${config.hm.home.homeDirectory}/.irssi/certs/libera.pem";
          };

          channels = {
            nixos.autoJoin = false;
            edctf.autoJoin = true;
          };
        };
      };
    };

    # https://blog.stigok.com/2020/04/16/building-a-custom-perl-package-for-nixos.html
    nixpkgs.config.packageOverrides =
      pkgs:
      let
        perlDeps = with pkgs.perlPackages; [
          Glib
          HTMLParser
          GlibObjectIntrospection
        ];

        typelibs = with pkgs; [
          libnotify
          gdk-pixbuf
          glib.out # .out instead of .bin for Gio.typelib
        ];
      in
      {
        irssi = pkgs.irssi.overrideAttrs (old: {
          buildInputs = old.buildInputs ++ [ pkgs.makeWrapper ];

          postFixup = ''
            wrapProgram "$out/bin/irssi" \
              --prefix PERL5LIB : "${pkgs.perlPackages.makePerlPath perlDeps}" \
              --prefix GI_TYPELIB_PATH : "${lib.makeSearchPath "lib/girepository-1.0" typelibs}"
          '';
        });
      };
  };
}
