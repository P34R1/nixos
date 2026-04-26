{
  self,
  inputs,
  lib,
  ...
}:

{
  flake.wrappers.fish = inputs.wrapper-modules.lib.wrapModule (
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options = with lib; {
        functions = mkOption { type = types.str; };
        binds = mkOption { type = types.str; };
        abbrs = mkOption { type = types.str; };
        interactiveShellInit = mkOption { type = types.str; };
      };

      config = {
        package = pkgs.fish;

        flags = {
          "-C" = "source ${config.constructFiles.config.path}";
        };

        constructFiles.config = {
          relPath = "config.fish";
          content = ''
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
            end
          '';
        };

        # drv.installPhase = ''
        #   runHook preInstall
        #   XDG_RUNTIME_DIR=/tmp ${lib.getExe config.package} --verify-config --config ${conf}
        #   runHook postInstall
        # '';
      };
    }
  );
}
