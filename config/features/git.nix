{ config, lib, ... }:

{
  options = with lib; {
    git = {
      enable = mkEnableOption "enables git configuration";

      userEmail = mkOption { type = types.str; };
      userName = mkOption { type = types.str; };
      signingKey = mkOption {
        type = types.str;
        default = ""; # Make optional
      };
    };

    lazygit.enable = mkEnableOption "enables lazygit";
  };

  config.hm = lib.mkIf config.git.enable {

    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.enable
    programs = {
      delta = {
        enable = true;
        enableGitIntegration = true;
      };

      git = {
        enable = true;

        lfs.enable = true;

        signing = lib.mkIf (config.git.signingKey != "") {
          signByDefault = true;
          key = config.git.signingKey;
        };

        ignores = [ ".direnv/" ];

        settings = {
          user.email = config.git.userEmail;
          user.name = config.git.userName;

          # Use main instead of master
          init.defaultBranch = "main";

          # Use SSH
          url."ssh://git@github.com/".insteadOf = "https://github.com/";
          url."ssh://git@codeberg.org/".insteadOf = "https://codeberg.org/";

          # https://www.youtube.com/watch?v=HJtxQPJUcJc
          rerere.enabled = true;

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

    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.lazygit.enable
    programs.lazygit = lib.mkIf config.lazygit.enable {
      enable = true;

      # https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md
      settings = {

      };
    };
  };
}
