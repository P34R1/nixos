{
  environment.systemPackages = with pkgs; [
    (pkgs.stdenv.mkDerivation {
      pname = "dorion";
      version = "6.1.0";
      src = pkgs.fetchurl {
        url = "https://github.com/SpikeHD/Dorion/releases/download/v6.1.0/Dorion_6.1.0_amd64_portable.tar.gz";
        sha256 = "";
      };

      runtimeDependencies = [
      ];

      nativeBuildInputs = [
      ];

      buildInputs = [
      ];

      installPhase = ''
        mkdir -p $out/bin
        cp dorion $out/bin/dorion
        cp updater $out/bin/updater
        chmod +x $out/bin/dorion
        chmod +x $out/bin/updater

        # Copy additional directories
        mkdir -p $out/share/dorion/plugins
        cp -r plugins/ $out/share/dorion/plugins/

        mkdir -p $out/share/dorion/themes
        cp -r themes/ $out/share/dorion/themes/

        mkdir -p $out/share/dorion/injection
        cp -r injection/ $out/share/dorion/injection/

        mkdir -p $out/share/dorion/icons
        cp -r icons/ $out/share/dorion/icons/

        # Copy any other necessary assets
        cp .portable $out/share/dorion/
      '';
    })
  ];
}
