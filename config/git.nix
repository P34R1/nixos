{ config, ... }:

{
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.enable
  programs.git = {
    enable = true;
    userEmail = "undeadgamer279@gmail.com";
    userName = "p34r1";

    extraConfig = {
      # Use main instead of master
      init.defaultBranch = "main";

      # Use SSH
      url."ssh://git@github.com/".insteadOf = "https://github.com/";

      # https://www.youtube.com/watch?v=HJtxQPJUcJc
      rerere.enabled = true;
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

      lo = "log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit";
    };
  };
}
