{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  dpkg,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  adwaita-icon-theme,
  gsettings-desktop-schemas,
  gtk3,
  gtk4,
  qt6,
  libX11,
  libXScrnSaver,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  libXrandr,
  libXrender,
  libXtst,
  libdrm,
  libkrb5,
  libuuid,
  libxkbcommon,
  libxshmfence,
  mesa,
  nspr,
  nss,
  pango,
  pipewire,
  snappy,
  udev,
  wayland,
  xdg-utils,
  coreutils,
  xorg,
  zlib,

  # Darwin dependencies
  unzip,
  makeWrapper,

  # command line arguments which are always set e.g "--disable-gpu"
  commandLineArgs ? "--password-store=gnome-libsecret",

  # Necessary for USB audio devices.
  pulseSupport ? stdenv.hostPlatform.isLinux,
  libpulseaudio,

  # For GPU acceleration support on Wayland (without the lib it doesn't seem to work)
  libGL,

  # For video acceleration via VA-API (--enable-features=VaapiVideoDecoder,VaapiVideoEncoder)
  libvaSupport ? stdenv.hostPlatform.isLinux,
  libva,
  enableVideoAcceleration ? libvaSupport,

  # For Vulkan support (--enable-features=Vulkan); disabled by default as it seems to break VA-API
  vulkanSupport ? true,
  addDriverRunpath,
  enableVulkan ? vulkanSupport,
}:

{
  pname,
  version,
  hash,
  url,
  platform,
}:

let
  inherit (lib)
    optional
    optionals
    makeLibraryPath
    makeSearchPathOutput
    makeBinPath
    optionalString
    strings
    escapeShellArg
    ;

  deps = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    gtk4
    libdrm
    libX11
    libGL
    libxkbcommon
    libXScrnSaver
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libxshmfence
    libXtst
    libuuid
    mesa
    nspr
    nss
    pango
    pipewire
    udev
    wayland
    xorg.libxcb
    zlib
    snappy
    libkrb5
    qt6.qtbase
  ] ++ optional pulseSupport libpulseaudio ++ optional libvaSupport libva;

  rpath = makeLibraryPath deps + ":" + makeSearchPathOutput "lib" "lib64" deps;
  binpath = makeBinPath deps;

  enableFeatures =
    optionals enableVideoAcceleration [
      "VaapiVideoDecodeLinuxGL"
      "VaapiVideoEncoder"
    ]
    ++ optional enableVulkan "Vulkan";

  disableFeatures =
    [ "OutdatedBuildDetector" ] # disable automatic updates
    # The feature disable is needed for VAAPI to work correctly: https://github.com/brave/brave-browser/issues/20935
    ++ optionals enableVideoAcceleration [ "UseChromeOSDirectVideoDecoder" ];
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    inherit url hash;
  };

  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;
  doInstallCheck = stdenv.hostPlatform.isLinux;

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      dpkg
      # override doesn't preserve splicing https://github.com/NixOS/nixpkgs/issues/132651
      # Has to use `makeShellWrapper` from `buildPackages` even though `makeShellWrapper` from the inputs is spliced because `propagatedBuildInputs` would pick the wrong one because of a different offset.
      (buildPackages.wrapGAppsHook3.override { makeWrapper = buildPackages.makeShellWrapper; })
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      unzip
      makeWrapper
    ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    # needed for GSETTINGS_SCHEMAS_PATH
    glib
    gsettings-desktop-schemas
    gtk3
    gtk4

    # needed for XDG_ICON_DIRS
    adwaita-icon-theme
  ];

  unpackPhase =
    if stdenv.hostPlatform.isLinux then
      "dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner"
    else
      "unzip $src";

  installPhase = lib.optionalString stdenv.hostPlatform.isLinux ''
    runHook preInstall

    mkdir -p $out $out/bin

    cp -R usr/share $out
    cp -R opt/ $out/opt

    export BINARYWRAPPER=$out/opt/brave.com/brave-nightly/brave-browser-nightly

    # Fix path to bash in $BINARYWRAPPER
    substituteInPlace $BINARYWRAPPER \
        --replace /bin/bash ${stdenv.shell}

    ln -sf $BINARYWRAPPER $out/bin/brave-browser-nightly

    for exe in $out/opt/brave.com/brave-nightly/{brave,chrome_crashpad_handler}; do
        patchelf \
            --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
            --set-rpath "${rpath}" $exe
    done

    # Fix paths
    substituteInPlace $out/share/applications/brave-browser-nightly.desktop \
        --replace /usr/bin/brave-browser-nightly $out/bin/brave-browser-nightly
    substituteInPlace $out/share/gnome-control-center/default-apps/brave-browser-nightly.xml \
        --replace /opt/brave.com $out/opt/brave.com
    substituteInPlace $out/share/menu/brave-browser-nightly.menu \
        --replace /opt/brave.com $out/opt/brave.com
    substituteInPlace $out/opt/brave.com/brave-nightly/default-app-block \
        --replace /opt/brave.com $out/opt/brave.com

    # Correct icons location
    #icon_sizes=("128")
    #for icon in ''${icon_sizes[*]}
    #do
    #    mkdir -p $out/share/icons/hicolor/$icon\x$icon/apps
    #
    #    ln -s $out/opt/brave.com/brave-nightly/product_logo_128_nightly.png $out/share/icons/hicolor/$icon\x$icon/apps/brave-browser-nightly.png
    #done
    # Only the 128 is provided in nightly
    rm -rf $out/share/icons/hicolor/128x128/apps
    mkdir -p $out/share/icons/hicolor/128x128/apps
    ln -s $out/opt/brave.com/brave-nightly/product_logo_128_nightly.png $out/share/icons/hicolor/128x128/apps/brave-browser-nightly.png

    # Not entirely sure what the purpose is here, but I don't like bad links
    rm -f $out/opt/brave.com/brave-nightly/brave-browser
    ln -s $out/opt/brave.com/brave-nightly/brave-browser-nightly $out/opt/brave.com/brave-nightly/brave-browser

    # Replace xdg-settings and xdg-mime
    ln -sf ${xdg-utils}/bin/xdg-settings $out/opt/brave.com/brave-nightly/xdg-settings
    ln -sf ${xdg-utils}/bin/xdg-mime $out/opt/brave.com/brave-nightly/xdg-mime

    runHook postInstall
  '';

  preFixup = ''
    # Add command line args to wrapGApp.
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : ${rpath}
      --prefix PATH : ${binpath}
      --suffix PATH : ${
        lib.makeBinPath [
          xdg-utils
          coreutils
        ]
      }
      ${
        optionalString (enableFeatures != [ ]) ''
          --add-flags "--enable-features=${strings.concatStringsSep "," enableFeatures}\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+,WaylandWindowDecorations}}"
        ''
      }
      ${
        optionalString (disableFeatures != [ ]) ''
          --add-flags "--disable-features=${strings.concatStringsSep "," disableFeatures}"
        ''
      }
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto}}"
      ${optionalString vulkanSupport ''
        --prefix XDG_DATA_DIRS  : "${addDriverRunpath.driverLink}/share"
      ''}
      --add-flags ${escapeShellArg commandLineArgs}
    )
  '';

  installCheckPhase = ''
    # Bypass upstream wrapper which suppresses errors
    $out/opt/brave.com/brave-nightly/brave-browser-nightly --version
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://brave.com/";
    description = "Privacy-oriented browser for Desktop and Laptop computers";
    changelog =
      "https://github.com/brave/brave-browser/blob/master/CHANGELOG_DESKTOP.md#"
      + lib.replaceStrings [ "." ] [ "" ] version;
    longDescription = ''
      Brave browser blocks the ads and trackers that slow you down,
      chew up your bandwidth, and invade your privacy. Brave lets you
      contribute to your favorite creators automatically.
    '';
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      uskudnik
      rht
      jefflabonte
      nasirhm
      buckley310
      matteopacini
    ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    mainProgram = "brave-browser-nightly";
  };
}
