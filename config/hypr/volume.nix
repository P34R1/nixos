{
  stdenv.mkDerivation rec {
    name = "volume";
    # disable unpackPhase etc
    phases = "buildPhase";
    builder = ./volume.sh;
    #nativeBuildInputs = [ coreutils dunst ];
    #PATH = lib.makeBinPath nativeBuildInputs;
    # only strings can be passed to builder
    #someString = "hello";
    #someNumber = builtins.toString 42;
    #someJson = builtins.toJSON { dst = "world"; };
  };
}
