{
  inputs,
  pkgs,
  ...
}:
# ================================================================ #
# =                           OUTDATED                           = #
# ================================================================ #
{
  imports = [
    ./features/general.nix
    ./features/programs/alacritty.nix
  ];

  home = {
    username = "evan";
    stateVersion = "22.11";
    homeDirectory = "/Users/evan/";
  };
}
