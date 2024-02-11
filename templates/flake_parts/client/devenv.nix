{pkgs, ...}: {
  languages.javascript-pnpm = {
    enable = true;
    package = pkgs.nodejs_20;
    pnpm = {
      install = {
        enable = true;
        directory = "client";
      };
    };
  };
}
