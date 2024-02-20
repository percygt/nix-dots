{username}:{
  services.syncthing = {
    enable = true;
    group = "data";
  };
  
  users.users.${username}.extraGroups = ["syncthing"];
}
