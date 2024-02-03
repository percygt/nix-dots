{
  pkgs,
  config,
  ...
}: {
  programs.xplr = {
    enable = true;
    # Optional params:
    plugins = {
      tree-view = pkgs.fetchFromGitHub {
        owner = "sayanarijit";
        repo = "tree-view.xplr";
        rev = "eeba82a862ca296db253d7319caf730ce1f034c2";
        hash = "sha256-v9KDupi5l3F+Oa5X6pc/Qz9EhaFIrnQK5sckjne/kIU=";
      };
    };
    extraConfig = ''
      require("tree-view").setup()
    '';
  };
}
