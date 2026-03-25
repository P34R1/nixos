{ self, inputs, ... }:

{
  flake.nixosModules.fzf =
    { pkgs, lib, ... }:
    let
      selfPackages = self.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      environment.systemPackages = [ selfPackages.fzf ];
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.fzf = inputs.wrapper-modules.lib.wrapPackage (
        { ... }:
        {
          inherit pkgs;
          package = pkgs.fzf;

          env.FZF_DEFAULT_COMMAND = "fd --color=always";
          flagSeparator = "=";
          flags = {
            # https://github.com/PatrickF1/fzf.fish/blob/main/functions/_fzf_wrapper.fish
            "--cycle" = true; # allows jumping between the first and last results
            "--layout" = "reverse"; # lists results top to bottom
            "--border" = true;
            "--height" = "90%"; # leaves space
            "--preview-window" = "wrap"; # wraps long lines
            "--marker" = "*"; # changes the multi-select marker
            "--ansi" = true;
          };
        }
      );
    };
}
