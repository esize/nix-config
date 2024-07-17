{ config
, pkgs
, lib
, inputs
, outputs
, system
, myLib
, hm
, ...
}: {
  imports = [
    ./hardware-configuration.nix
    outputs.nixosModules.default
  ];

  myNixOS = {
    bundles.users.enable = true;
    home-users = {
      "evan" = {
        userConfig = ./home.nix;
        userSettings = {
          extraGroups = [ "docker" "libvirtd" "networkmanager" "wheel" ];
        };
      };
    };
  };

  inputs.wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "evan";
    startMenuLaunchers = true;
  };


  # vscode workaround
  systemd.user = {
    paths.vscode-remote-workaround = {
      wantedBy = [ "default.target" ];
      pathConfig.PathChanged = "%h/.vscode-server/bin";
    };

    services.vscode-remote-workaround.script = ''
      for i in ~/.vscode-server/bin/*; do
        echo "Fixing vscode-server in $i..."
        ln -sf ${pkgs.nodejs-18_x}/bin/node $i/node
      done
    '';
  };

  system.name = "wsl-nixos";
  system.nixos.label = "wsl-nixos";

  security.sudo.wheelNeedsPassword = false;

  networking.hostName = "wsl-nixos";

  # Enable networking
  networking.networkmanager.enable = true;

  virtualisation.docker.enable = true;

  services.openssh.enable = true;

  # ================================================================ #
  # =                         DO NOT TOUCH                         = #
  # ================================================================ #

  system.stateVersion = "23.05";
}
