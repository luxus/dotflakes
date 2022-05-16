let
  luxus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID/AjBtg8D4lMoBkp2L3dDb5EmkOGr1v/Ns1wwRoKds4 luxuspur@gmail.com";
  kai = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID/AjBtg8D4lMoBkp2L3dDb5EmkOGr1v/Ns1wwRoKds4 luxuspur@gmail.com";
  trustedUsers = [ luxus kai ];
in {
  "wireless.env.age".publicKeys = trustedUsers;

#  "espanso/personal.yml.age".publicKeys = trustedUsers;
#  "espanso/work.yml.age".publicKeys = trustedUsers;
}
