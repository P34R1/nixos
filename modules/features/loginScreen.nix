{ self, inputs, ... }:

{
  flake.nixosModules.loginScreen =
    {
      config,
      pkgs,
      lib,
      ...
    }:

    let
      inherit (lib.strings)
        concatMapStrings
        concatMapStringsSep
        ;

      cfg = config.loginScreen;

      # \033[1m => bold        \033[0m => unbold
      # https://ryantm.github.io/nixpkgs/functions/library/strings/#function-library-lib.strings.concatMapStrings
      enabledOptions = concatMapStrings (
        opt: "\\033[1m[${opt.indicator}]\\033[0m - ${opt.name}\\n"
      ) cfg.window-managers;

      # https://ryantm.github.io/nixpkgs/functions/library/strings/#function-library-lib.strings.concatMapStringsSep
      enabledCases = concatMapStringsSep "\n" (
        opt: "${opt.indicator}) exec ${opt.command};;"
      ) cfg.window-managers;
    in
    {
      options.loginScreen = with lib; {
        autoLogin = mkOption { type = types.bool; };
        user = mkOption {
          type = types.str;
          default = "";
        };

        window-managers = mkOption {
          type = types.listOf (
            types.submodule {
              options = {
                name = mkOption { type = types.str; };
                command = mkOption { type = types.str; };
                indicator = mkOption { type = types.str; };
              };
            }
          );
        };
      };

      config = {
        # https://wiki.archlinux.org/title/Xinit#Autostart_X_at_login
        programs.bash = {
          enable = true;
          loginShellInit = ''
            if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
              printf "${enabledOptions}"

              stty -icanon -echo
              choice=$(dd bs=1 count=1 2>/dev/null)
              stty icanon echo

              case "$choice" in
                ${enabledCases}
              esac
            fi
          '';
        };

        services.getty = {
          # https://www.reddit.com/r/NixOS/comments/161uvb5/remove_nixoshelp_reminder_on_tty/
          helpLine = lib.mkForce "";

          # skip username and pass
          autologinUser = lib.mkIf cfg.autoLogin "${cfg.user}";

          # skip username
          extraArgs = lib.mkIf (!cfg.autoLogin && cfg.user != "") [
            "--skip-login"
            "--login-options"
            "${cfg.user}"
          ];
        };
      };
    };

}
