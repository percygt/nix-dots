{ prev, final }:
{
  material-symbols = prev.unstable.material-symbols.overrideAttrs (oldAttrs: {
    version = "4.0.0-unstable-2025-04-11";
    src = final.fetchFromGitHub {
      owner = "google";
      repo = "material-design-icons";
      rev = "941fa95d7f6084a599a54ca71bc565f48e7c6d9e";
      hash = "sha256-5bcEh7Oetd2JmFEPCcoweDrLGQTpcuaCU8hCjz8ls3M=";
      sparseCheckout = [ "variablefont" ];
    };
  });
  inherit (prev.unstable)
    fish
    nushell
    nu_scripts
    carapace
    swaynotificationcenter
    waybar
    syncthing
    tailscale
    ;

  ripgrep = prev.unstable.ripgrep.override { withPCRE2 = true; };
  borgmatic = prev.unstable.borgmatic.override { enableSystemd = false; };
  btop = prev.unstable.btop.override {
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
  gnome-keyring = prev.gnome-keyring.overrideAttrs (oldAttrs: {
    configureFlags = prev.lib.lists.remove "--enable-ssh-agent" oldAttrs.configureFlags or [ ] ++ [
      "--disable-ssh-agent"
    ];
  });
  # pythonPackagesExtensions = (prev.pythonPackagesExtensions or [ ]) ++ [
  #   (_python-final: python-prev: {
  #     # NOTE: could patch nixpkgs for broken grammars using
  #     # `applyPatches` + <https://github.com/dtomvan/nixpkgs/commit/f0a1b58b7c882690540b893cd27422dfbf7c2ce4.patch>
  #     tree-sitter =
  #       let
  #         version = "0.24.0";
  #       in
  #       python-prev.tree-sitter.overridePythonAttrs {
  #         inherit version;
  #         src = final.fetchPypi {
  #           inherit version;
  #           pname = "tree-sitter";
  #           hash = "sha256-q9la9lyi9Pfso1Y0M5HtZp52Tzd0i1NSlG8A9/x45zQ=";
  #         };
  #         # NOTE: not in the branch but was required on my system
  #         doCheck = false;
  #       };
  #     tree-sitter-rust =
  #       let
  #         version = "0.23.2";
  #       in
  #       python-prev.tree-sitter-rust.overridePythonAttrs {
  #         inherit version;
  #         src = final.fetchFromGitHub {
  #           owner = "tree-sitter";
  #           repo = "tree-sitter-rust";
  #           tag = "v${version}";
  #           hash = "sha256-aT+tlrEKMgWqTEq/NHh8Vj92h6i1aU6uPikDyaP2vfc=";
  #         };
  #       };
  #     textual = python-prev.textual.overridePythonAttrs {
  #       meta.broken = false;
  #     };
  #   })
  # ];
}
