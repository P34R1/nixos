{ self, inputs, ... }:

{
  flake.nixosModules.beets =
    { pkgs, lib, ... }:
    let
      selfPackages = self.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      environment.systemPackages = [ selfPackages.beets ];
    };

  perSystem =
    { pkgs, ... }:
    let
      py = pkgs.python314Packages;
      beets-getlrc = py.buildPythonPackage (finalAttrs: {
        pname = "beets-getlrc";
        version = "0.1.15";
        pyproject = true;

        src = pkgs.fetchFromGitHub {
          owner = "jaedonswanson";
          repo = "beets-getlrc";
          tag = "v${finalAttrs.version}";
          hash = "sha256-OVZcBSN3S2VCST+HJvTdJKzPtrmo1sPfEmfVDpFnXtw=";
        };

        nativeBuildInputs = with py; [ beets-minimal ];
        dependencies = with py; [ requests ];
        build-system = with py; [
          uv-build
          setuptools
        ];
      });

      plugin = pkg: {
        enable = true;
        propagatedBuildInputs = [ pkg ];
      };
    in
    {
      packages.beets = inputs.wrapper-modules.lib.wrapPackage (
        { ... }:
        {
          inherit pkgs;
          package = py.beets.override {
            pluginOverrides = with py; {
              filetote = plugin beets-filetote;
              importreplace = plugin beets-importreplace;
              getlrc = plugin beets-getlrc;
            };
          };
        }
      );
    };
}
