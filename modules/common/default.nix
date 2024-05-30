{username, ...}: {
  imports = [./nixos];
  home-manager.users.${username} = {
    imports = [./home-manager];
  };
}
