{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.modules.dev.enable {
    programs.go = {
      enable = true;
      goPath = ".local/share/go";
      goBin = ".local/share/go/bin";
    };
    home.packages =
      (with pkgs; [
        babashka
        bfg-repo-cleaner # Git history cleaner
      ])
      ++ (import ./+extras/langPackages.nix pkgs);
    home.file =
      let
        ql = pkgs.fetchFromGitHub {
          owner = "quicklisp";
          repo = "quicklisp-client";
          rev = "d601e0d0c3e104d8a5b0aad741fe91b25cb3d1ba";
          hash = "sha256-ISHk66HWoo5tCD4cyMDn2SUSOVGCD1+BcSwB16njLEQ=";
        };
      in

      {
        # ".sbclrc".text =
        #   #lisp
        #   ''
        #     (let ((quicklisp-init (merge-pathnames ".quicklisp/setup.lisp"
        #                                            (user-homedir-pathname))))
        #       (when (probe-file quicklisp-init)
        #         (load quicklisp-init)))
        #   '';
        # ".quicklisp/setup.lisp".source = "${ql}/setup.lisp";
        # ".quicklisp/asdf.lisp".source = "${ql}/asdf.lisp";
      };
  };
}
