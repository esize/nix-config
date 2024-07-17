{ inputs, ... }: {
  programs.git = {
    enable = true;
    userEmail = "evan@wool.homes";
    userName = "Evan Sizemore";
  };
}
