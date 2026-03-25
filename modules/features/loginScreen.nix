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

      # \033[1m => bold        \033[0m => unbold
      # https://ryantm.github.io/nixpkgs/functions/library/strings/#function-library-lib.strings.concatMapStrings
      enabledOptions = concatMapStrings (
        opt: "\\033[1m[${opt.indicator}]\\033[0m - ${opt.name}\\n"
      ) self.window-managers;

      # https://ryantm.github.io/nixpkgs/functions/library/strings/#function-library-lib.strings.concatMapStringsSep
      enabledCases = concatMapStringsSep "\n" (
        opt: "${opt.indicator}) exec ${opt.command};;"
      ) self.window-managers;

      cfg = config.loginScreen;
    in
    {
      options.loginScreen = with lib; {
        autoLogin = mkOption { type = types.bool; };
        user = mkOption {
          type = types.str;
          default = "";
        };
      };

      config = {
        # https://wiki.archlinux.org/title/Xinit#Autostart_X_at_login
        hm.home.file.".bash_profile".text = ''
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
