{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mpdlrc";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "eNV25";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-b/aj+kgovErp7zqzE53/ZfwkxFstOQ8GNl5fUSwIkTQ=";
  };

  vendorHash = "sha256-j9YzFnwdi3ZtNVy+uQET0S+sHbOkaNCfFC/B/a720HE=";
  env.GOWORK = "off";

  # doCheck = false;
  # subPackages = [ "cmd/${pname}" ];
}
