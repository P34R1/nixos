let
  server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJftHKesu+DWn3OWPUixdQcgMvVvNY7Y4als3z9oapbJ";
in
{
  "modules/features/server/cloudflare.age".publicKeys = [
    server
  ];

  "modules/features/server/nginx/slskd.age".publicKeys = [
    server
  ];
}
