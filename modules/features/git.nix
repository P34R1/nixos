{ self, inputs, ... }:

{
  flake.nixosModules.git =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.git;
    in
    {
      options.git = with lib; {
        userEmail = mkOption { type = types.str; };
        userName = mkOption { type = types.str; };
        signingKey = mkOption {
          type = types.str;
          default = ""; # Make optional
        };
      };

      config = {
        programs.gnupg.agent = {
          enable = true;
          pinentryPackage = pkgs.pinentry-curses;
        };

        environment.systemPackages = with pkgs; [
          (writeShellScriptBin "gitignore" "${curl}/bin/curl -sL https://www.gitignore.io/api/$argv")
          (self.packages.${pkgs.stdenv.hostPlatform.system}.jujutsuInitial.wrap {
            settings = {
              user.name = cfg.userName;
              user.email = cfg.userEmail;

              git.sign-on-push = lib.mkIf (cfg.signingKey != "") true;
              signing = lib.mkIf (cfg.signingKey != "") {
                behavior = "drop";
                backend = "gpg";
                backends.gpg.program = lib.getExe pkgs.gnupg;
                key = cfg.signingKey;
              };
            };
          })
        ];

        programs.git = {
          enable = true;
          package = self.packages.${pkgs.stdenv.hostPlatform.system}.gitInitial.wrap {
            settings = {
              user.name = cfg.userName;
              user.email = cfg.userEmail;

              signing = lib.mkIf (cfg.signingKey != "") {
                signByDefault = true;
                key = cfg.signingKey;
              };
            };
          };
        };
      };
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.jujutsuInitial = inputs.wrapper-modules.wrappers.jujutsu.wrap {
        inherit pkgs;
        settings = {
          aliases = {
            d = [ "diff" ];
          };

          ui.default-command = [
            "log"
            "--no-pager"
            "--reversed"
            "--summary"
            "--limit"
            "15"
          ];
        };
      };

      packages.gitInitial = inputs.wrapper-modules.wrappers.git.wrap {
        inherit pkgs;

        # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.enable
        # delta = {
        #   enable = true;
        #   enableGitIntegration = true;
        # };

        settings =
          let
            gitignore = pkgs.writeText "globalignore" ''
              .direnv/
              .jj/
            '';
          in
          {
            init.defaultBranch = "main";
            core.excludesfile = "${gitignore}";

            # Use SSH
            url."ssh://git@github.com/".insteadOf = "https://github.com/";
            url."ssh://git@codeberg.org/".insteadOf = "https://codeberg.org/";

            # https://www.youtube.com/watch?v=HJtxQPJUcJc
            rerere.enabled = true;
            lfs.enable = true;

            alias = {
              st = "status -s";
              sta = "status";

              br = "branch";
              bra = "branch -a";
              co = "checkout";

              # https://www.youtube.com/watch?v=xN1-2p06Urc
              pr = "pull --rebase";
              puf = "push --force-with-lease";
              amend = "commit --amend --no-edit";
              unadd = "reset HEAD";

              lo = "log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit";
            };
          };
      };
    };
}
