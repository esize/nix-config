let
  # all public keys in this file
  githubKeys = [
    # https://github.com/esize.keys
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM1Se3/HbGulTdf2deJRN7wIR0uXnKQuHf9Za+zO+k2e"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDRkN0RNO6342OWJeOEWnZd0mW23eEPU9WS97D3CT+D0"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILyTlJ30ZVOPqZaaN4FMpYPQAJ1sp5YYCnOvLyC0gCcb"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICsAIGNNY6EMMMRe66UqVc6OJwLpTUGtPGTVZH6tN+88"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOBtq7Bw1OCa7oB34Oa7Gz4U8d2U6EneuRC28Ep7N1Ud"
  ];
  # ssh-keyscan <ip> or sudo cat /etc/ssh/ssh_host_ed25519_key.pub for root keys
  desktop-wsl-ubuntu = {
    root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMVoPnPNuc4R1iS47+sQa9yNhyL1x6Gyk3/toz/0prJs";
    user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILyTlJ30ZVOPqZaaN4FMpYPQAJ1sp5YYCnOvLyC0gCcb";
  };

  portainer-server = {
    root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJOqrJBzszGSmoy+CrZKnARnVr6FHyr6vSt6TtFPo1N";
    user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIABHIlDFAW2wXwxETOZESBCC73JTgeoJ2mi39KFjZbKD";
  };

  lab-server = {
    root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILT2/UpAuZhgmL6myJCRA7VAeQExpxVNGxuy72FmfUXm";
    user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOBtq7Bw1OCa7oB34Oa7Gz4U8d2U6EneuRC28Ep7N1Ud";
  };

  hosts = [ desktop-wsl-ubuntu portainer-server lab-server ];

  getUser = host: host.user;
  getRoot = host: host.root;
  getAllKeysForHost = host: [ (getUser host) (getRoot host) ];

  knownUsers = (builtins.map getUser hosts);
  users = githubKeys ++ knownUsers;
  systems = (builtins.map getRoot hosts);
  allKeys = users ++ systems;

  serverSecretKeys = knownUsers ++ [
    (getRoot portainer-server)
  ]; # allow all user keys to modify the thicc server secrets
in
{
  "evan-pass.age".publicKeys = allKeys;
  "mopidy-spotify.age".publicKeys = allKeys;

  "freshrss-user-pass.age".publicKeys = serverSecretKeys;
  "caddy-cloudflare.age".publicKeys = serverSecretKeys;
  # other stuff ...
}
