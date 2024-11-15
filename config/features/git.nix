{ config, lib, ... }:

{
  options = {
    git.enable = lib.mkEnableOption "enables git configuration";

    lazygit.enable = lib.mkEnableOption "enables lazygit";
  };

  config.hm = lib.mkIf config.git.enable {

    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.enable
    programs.git = {
      enable = true;
      userEmail = "undeadgamer279@gmail.com";
      userName = "pearl";
      delta.enable = true;
      lfs.enable = true;

      signing = {
        signByDefault = true;
        key = "D4F0D505725B265F";
      };

      extraConfig = {
        # Use main instead of master
        init.defaultBranch = "main";

        # Use SSH
        url."ssh://git@github.com/".insteadOf = "https://github.com/";
        url."ssh://git@codeberg.org/".insteadOf = "https://codeberg.org/";

        # https://www.youtube.com/watch?v=HJtxQPJUcJc
        rerere.enabled = true;

        core.excludesFile = "~/.config/git/ignore";
      };

      aliases = {
        st = "status -s";
        sta = "status";

        br = "branch";
        bra = "branch -a";
        co = "checkout";

        # https://www.youtube.com/watch?v=xN1-2p06Urc
        pr = "pull --rebase";
        amend = "commit -a --amend --no-edit";
        unadd = "reset HEAD";

        lo = "log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit";
      };
    };

    home.file.".config/git/ignore".text = ''
      .direnv/
    '';

    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.lazygit.enable
    programs.lazygit = lib.mkIf config.lazygit.enable {
      enable = true;

      # https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md
      settings = {

      };
    };
  };
}
