{ prev, inputs }:
{
  # Overriding to stable globally for these packages
  auto-cpufreq = prev.stable.auto-cpufreq; # BUG: unstable failing to compile, python stuff error
  libnotify = prev.stable.libnotify; # BUG: notify-send unstable not showing icons

  ripgrep = prev.ripgrep.override { withPCRE2 = true; };
  borgmatic = prev.borgmatic.override { enableSystemd = false; };
  btop = prev.btop.override {
    cudaSupport = true;
    rocmSupport = true;
  };
  quickemu = prev.quickemu.overrideAttrs (oldAttrs: {
    src = inputs.quickemu;
  });
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
  waybar = prev.waybar.override {
    experimentalPatches = true;
    swaySupport = true;
    cavaSupport = false;
    hyprlandSupport = false;
  };
}
