{ config, pkgs, ... }:

{
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fish.enable
  programs.fish = {
    enable = true;

    functions = {
      gitignore = "curl -sL https://www.gitignore.io/api/$argv";
    };

    interactiveShellInit = ''
      function fish_greeting
        set DIR_COLORSCRIPTS "/home/pearl/.local/share/colorscripts"
        bash "$DIR_COLORSCRIPTS/$(basename (random choice $(ls $DIR_COLORSCRIPTS)))"
      end

#      function fish_prompt
        # This shows up as USER@HOST /home/user/ >, with the directory colored
        # $USER and $hostname are set by fish, so you can just use them
        # instead of using `whoami` and `hostname`
#        printf '%s@%s %s%s%s > ' $USER $hostname \
#          (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
#      end
    '';
  };


  programs.fish.plugins = [
    {
      name = "z";
      src = pkgs.fetchFromGitHub {
        owner = "jethrokuan";
        repo = "z";
        rev = "85f863f20f24faf675827fb00f3a4e15c7838d76";
        sha256 = "sha256-+FUBM7CodtZrYKqU542fQD+ZDGrd2438trKM0tIESs0=";
      };
    }

   # {
   #   name = "dracula";
   #   src = pkgs.fetchFromGitHub {
   #     owner = "dracula";
   #     repo = "fish";
   #     rev = "269cd7d76d5104fdc2721db7b8848f6224bdf554";
   #     sha256 = "sha256-Hyq4EfSmWmxwCYhp3O8agr7VWFAflcUe8BUKh50fNfY=";
   #   };
   # }

    {
      name = "fzf";
      src = pkgs.fetchFromGitHub {
        owner = "PatrickF1";
        repo = "fzf.fish";
        rev = "8920367cf85eee5218cc25a11e209d46e2591e7a";
        sha256 = "sha256-T8KYLA/r/gOKvAivKRoeqIwE2pINlxFQtZJHpOy9GMM=";
      };
    }

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
