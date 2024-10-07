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
    '';
  };
}
