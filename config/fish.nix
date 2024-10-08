{ config, pkgs, ... }:

{
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fish.enable
  programs.fish = {
    enable = true;

    functions = {
      gitignore = "curl -sL https://www.gitignore.io/api/$argv";
    };

    # https://fishshell.com/docs/current/cmds/abbr.html
    # https://github.com/nix-community/home-manager/blob/master/modules/programs/fish.nix#L141
    # Line might change in the future
    # Find abbrModule = types.submodule {
    shellAbbrs = {
      rb = "sudo nixos-rebuild switch --flake /home/pearl/nixos#main";

      ga = "git add .";
      gc = {
        expansion = "git commit -m \"|\"";
        setCursor = "|";
      };
      gp = "git push";
      gs = "git status";
      gd = "git diff --cached";

      v = "nvim";
      l = "ls -al";
    };

    interactiveShellInit = ''
      function fish_greeting
        set DIR_COLORSCRIPTS "/home/pearl/.local/share/colorscripts"
        bash "$DIR_COLORSCRIPTS/$(basename (random choice $(ls $DIR_COLORSCRIPTS)))"
      end
    '';
  };


  programs.fish.plugins = [

    # https://github.com/jethrokuan/z
    {
      name = "z";
      src = pkgs.fetchFromGitHub {
        owner = "jethrokuan";
        repo = "z";
        rev = "85f863f20f24faf675827fb00f3a4e15c7838d76";
        sha256 = "sha256-+FUBM7CodtZrYKqU542fQD+ZDGrd2438trKM0tIESs0=";
      };
    }

    # https://github.com/meaningful-ooo/sponge
    {
      name = "sponge";
      src = pkgs.fetchFromGitHub {
        owner = "meaningful-ooo";
        repo = "sponge";
        rev = "384299545104d5256648cee9d8b117aaa9a6d7be";
        sha256 = "sha256-MdcZUDRtNJdiyo2l9o5ma7nAX84xEJbGFhAVhK+Zm1w=";
      };
    }

    # https://github.com/PatrickF1/fzf.fish
    {
      name = "fzf";
      src = pkgs.fetchFromGitHub {
        owner = "PatrickF1";
        repo = "fzf.fish";
        rev = "8920367cf85eee5218cc25a11e209d46e2591e7a";
        sha256 = "sha256-T8KYLA/r/gOKvAivKRoeqIwE2pINlxFQtZJHpOy9GMM=";
      };
    }

    # https://github.com/jorgebucaran/hydro
    {
      name = "hydro";
      src = pkgs.fetchFromGitHub {
        owner = "jorgebucaran";
        repo = "hydro";
        rev = "bc31a5ebc687afbfb13f599c9d1cc105040437e1";
        sha256 = "sha256-0MMiM0NRbjZPJLAMDXb+Frgm+du80XpAviPqkwoHjDA=";
      };
    }
  ];
}
