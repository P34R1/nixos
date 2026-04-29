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
      inherit (lib.strings) concatMapStrings;
      cfg = config.loginScreen;

      # \033[1m => bold        \033[0m => unbold
      # https://ryantm.github.io/nixpkgs/functions/library/strings/#function-library-lib.strings.concatMapStrings
      window-managers =
        cfg.window-managers
        |> map (wm: {
          label = "\\033[1m[${wm.key}]\\033[0m - ${wm.name}\\n";
          handler = "${wm.key}) exec ${wm.command};;";
        });

      menuUi = window-managers |> concatMapStrings ({ label, ... }: label);
      menuLogic = window-managers |> concatMapStrings ({ handler, ... }: handler);
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
                key = mkOption { type = types.str; };
                name = mkOption { type = types.str; };
                command = mkOption { type = types.str; };
              };
            }
          );
        };
      };

      config = {
        # https://wiki.archlinux.org/title/Xinit#Autostart_X_at_login
        programs.bash.loginShellInit = ''
          if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
            printf -- "--- Select Window Manager ---\n"
            printf "${menuUi}"

            stty -icanon -echo
            choice=$(dd bs=1 count=1 2>/dev/null)
            stty icanon echo

            case "$choice" in
              ${menuLogic}
              *) printf "Invalid choice, staying on tty...\n" ;;
            esac
          fi
        '';

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
