{ prev, inputs }:
{
  swayfx = prev.swayfx.override {
    inherit (inputs.nix-sources.packages.${prev.system}) swayfx-unwrapped;
  };

  ripgrep = prev.ripgrep.override { withPCRE2 = true; };
  borgmatic = prev.borgmatic.override { enableSystemd = false; };
  logseq = prev.logseq.overrideAttrs (oldAttrs: {
    postFixup = ''
      makeWrapper ${prev.electron}/bin/electron $out/bin/${oldAttrs.pname} \
        --add-flags $out/share/${oldAttrs.pname}/resources/app \
        --add-flags "--use-gl=desktop" \
        --prefix LD_LIBRARY_PATH : "${prev.lib.makeLibraryPath [ prev.stdenv.cc.cc.lib ]}"
    '';
  });
  gnome-keyring = prev.gnome-keyring.overrideAttrs (oldAttrs: {
    configureFlags = prev.lib.lists.remove "--enable-ssh-agent" oldAttrs.configureFlags or [ ] ++ [
      "--disable-ssh-agent"
    ];
  });
  waybar = prev.waybar.override {
    cavaSupport = false;
    evdevSupport = true;
    experimentalPatches = false;
    hyprlandSupport = false;
    inputSupport = false;
    jackSupport = false;
    mpdSupport = false;
    mprisSupport = false;
    nlSupport = true;
    pulseSupport = true;
    rfkillSupport = false;
    runTests = false;
    sndioSupport = false;
    swaySupport = true;
    traySupport = true;
    udevSupport = false;
    upowerSupport = false;
    wireplumberSupport = false;
    withMediaPlayer = false;
  };
  google-fonts =
    (prev.google-fonts.overrideAttrs (oldAttrs: {
      nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ prev.perl ];
      installPhase =
        (oldAttrs.installPhase or "")
        + ''
          skip=("NotoColorEmoji")
          readarray -t fonts < <(find . -name '*.ttf' -exec basename '{}' \; | perl -pe 's/(.+?)[[.-].*/\1/g' | sort | uniq)
          for font in "''${fonts[@]}"; do
            [[ "_''${skip[*]}_" =~ _''${font}_ ]] && continue
            find . -name "''${font}*.ttf" -exec install -m 444 -Dt $dest '{}' +
          done
        '';
    })).override
      {
        # Don't install fonts in the original `installPhase`
        fonts = [ "__NO_FONT__" ];
      };
}
