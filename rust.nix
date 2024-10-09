({ pkgs, inputs, ... }: {
  nixpkgs.overlays = [
    inputs.fenix.overlays.default
    (final: prev: {
      zigpkgs = inputs.zig.packages.${prev.system};
    })
  ];

  environment.systemPackages = with pkgs; [
    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    rust-analyzer-nightly
  ];
})
