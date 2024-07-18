{pkgs, ...}: {
  hardware.uinput.enable = true;
  users.groups.uinput.members = ["evan"];
  users.groups.input.members = ["evan"];
}
