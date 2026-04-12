{
  self,
  inputs,
  lib,
  ...
}:

{
  flake.wrappers.fish = inputs.wrapper-modules.lib.evalModule (
    {
      config,
      wlib,
      lib,
      pkgs,
      ...
    }:
    let
      plugins = lib.concatStringsSep " \\\n  " config.plugins;

      conf = pkgs.writeText "config.fish" ''
        # Only execute this file once per shell.
        set -q __fish_config_sourced; and exit
        set -g __fish_config_sourced 1

        status is-interactive; and begin
          # Functions
          ${config.functions}

          # Binds
          bind -ea # reset binds
          ${config.binds}

          # Abbreviations
          ${config.abbrs}

          # Interactive shell initialisation
          ${config.interactiveShellInit}

          # Plugins
          set --local plugins \
            ${plugins}

          for p in $plugins
              set -a fish_function_path $p/functions

              for f in $p/conf.d/*.fish
                  test -f $f; and source $f
              end
          end
        end
      '';
    in
    {
      imports = [ wlib.modules.default ];

      options = with lib; {
        functions = mkOption { type = types.str; };
        binds = mkOption { type = types.str; };
        abbrs = mkOption { type = types.str; };
        interactiveShellInit = mkOption { type = types.str; };
        plugins = mkOption { type = types.listOf types.package; };
      };

      config = {
        package = pkgs.fish;

        # drv.installPhase = ''
        #   runHook preInstall
        #   XDG_RUNTIME_DIR=/tmp ${lib.getExe config.package} --verify-config --config ${conf}
        #   runHook postInstall
        # '';

        flags = {
          "-C" = "source ${conf}";
        };
      };
    }
  );
}
