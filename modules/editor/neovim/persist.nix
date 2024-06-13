{username, ...}: {
  environment.persistence = {
    "/persist" = {
      users.${username} = {
        directories = [
          ".local/share/nvim"
          ".local/cache/nvim"
          ".local/state/nvim"
        ];
      };
    };
  };
}
