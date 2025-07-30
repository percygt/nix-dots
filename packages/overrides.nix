{ prev, final }:
{
  libnotify = prev.stable.libnotify; # BUG: notify-send unstable not showing icons
  chromium = prev.stable.chromium;
  pythonPackagesExtensions = (prev.pythonPackagesExtensions or [ ]) ++ [
    (_python-final: python-prev: {
      # NOTE: could patch nixpkgs for broken grammars using
      # `applyPatches` + <https://github.com/dtomvan/nixpkgs/commit/f0a1b58b7c882690540b893cd27422dfbf7c2ce4.patch>
      tree-sitter =
        let
          version = "0.24.0";
        in
        python-prev.tree-sitter.overridePythonAttrs {
          inherit version;
          src = final.fetchPypi {
            inherit version;
            pname = "tree-sitter";
            hash = "sha256-q9la9lyi9Pfso1Y0M5HtZp52Tzd0i1NSlG8A9/x45zQ=";
          };
          # NOTE: not in the branch but was required on my system
          doCheck = false;
        };
      tree-sitter-rust =
        let
          version = "0.23.2";
        in
        python-prev.tree-sitter-rust.overridePythonAttrs {
          inherit version;
          src = final.fetchFromGitHub {
            owner = "tree-sitter";
            repo = "tree-sitter-rust";
            tag = "v${version}";
            hash = "sha256-aT+tlrEKMgWqTEq/NHh8Vj92h6i1aU6uPikDyaP2vfc=";
          };
        };
      textual = python-prev.textual.overridePythonAttrs {
        meta.broken = false;
      };
    })
  ];
  ripgrep = prev.ripgrep.override { withPCRE2 = true; };
  borgmatic = prev.borgmatic.override { enableSystemd = false; };
  btop = prev.btop.override {
    cudaSupport = true;
    rocmSupport = true;
  };
  revanced-cli = prev.revanced-cli.overrideAttrs (oldAttrs: rec {
    version = "5.0.1";
    src = prev.fetchurl {
      url = "https://github.com/inotia00/revanced-cli/releases/download/v${version}/revanced-cli-${version}-all.jar";
      hash = "sha256-1aSlYQ7utiLeqSZaBF7Nd8WYwBCMUDDKVgVir6YyT+U=";
    };
  });
  logseq = prev.logseq.overrideAttrs (oldAttrs: {
    postFixup = ''
      makeWrapper ${prev.electron}/bin/electron $out/bin/${oldAttrs.pname} \
        --add-flags $out/share/${oldAttrs.pname}/resources/app \
        --add-flags "--use-gl=angle" \
        --prefix LD_LIBRARY_PATH : "${prev.lib.makeLibraryPath [ prev.stdenv.cc.cc.lib ]}"
    '';
  });
  gnome-keyring = prev.gnome-keyring.overrideAttrs (oldAttrs: {
    configureFlags = prev.lib.lists.remove "--enable-ssh-agent" oldAttrs.configureFlags or [ ] ++ [
      "--disable-ssh-agent"
    ];
  });
}
