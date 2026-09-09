{ self, inputs, ... }:

{
  flake.nixosConfigurations.wsl = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      wslConfiguration
      inputs.nixos-wsl.nixosModules.default
    ];
  };

  flake.nixosModules.wslConfiguration =
    {
      pkgs,
      lib,
      config,
      ...
    }:

    {
      imports = with self.nixosModules; [
        coreBundle
        agenix
      ];

      git = {
        userEmail = "vincent.fortin279@gmail.com";
        userName = "pearl";
        signingKey = "F293EAC909C12FF5";
      };

      nix.flakePath = "/home/pearl/nixos/";

      # https://github.com/nix-community/NixOS-WSL
      wsl = {
        enable = true;
        defaultUser = "pearl";
      };

      network.enable = false;
      networking.hostName = "wsl";

      # autostart fish
      programs.bash.loginShellInit = ''
        if [[ $(${lib.getExe' pkgs.procps "ps"} --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]] then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec fish $LOGIN_OPTION
        fi
      '';

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      system.stateVersion = "26.05"; # Don't change for simplicity!
    };
}
