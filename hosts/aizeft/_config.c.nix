{
  modules = {
    fileSystem = {
      udisks.enable = true;
      btrfsAutoscrub.enable = true;
      ephemeral.enable = true;
      persist.enable = true;
    };
    app = {
      zen.enable = true;
      librewolf.enable = true;
      brave.enable = true;
      # brave-nightly.enable = true;
      quickemu.enable = true;
      flatpak.enable = true;
      chromium.enable = true;
      chromium-webapps = {
        chatgpt.enable = true;
        discord.enable = true;
        element.enable = true;
        zoom.enable = true;
      };
    };
    core = {
      powermanagement.enable = true;
      wifi.enable = true;
      # autoupgrade.enable = true;
      audio.enable = true;
      zram.enable = true;
    };
    drivers = {
      adb.enable = true;
      bluetooth.enable = true;
      printer.enable = true;
    };
    dev = {
      gh.enable = true;
      ghq.enable = true;
      glab.enable = true;
      process-compose.enable = true;
      tools.enable = true;
    };
    security = {
      extraPackages.enable = true;
      gpg.enable = true;
      keepass.enable = true;
      borgmatic.enable = true;
      restic.enable = true;
      sops.enable = true;
      ssh.enable = true;
    };
    editor = {
      emacs.enable = true;
      # zed.enable = true;
      helix.enable = true;
      # vscode.enable = true;
    };
    networking = {
      vpn.enable = true;
      # avahi.enable = true;
      tailscale.enable = true;
      syncthing.enable = true;
    };
    # pentesting = {
    #   wireless.enable = true;
    #   malware.enable = true;
    #   traffic.enable = true;
    #   proxies.enable = true;
    #   terminals.enable = true;
    # };
    terminal = {
      foot.enable = true;
      xfce4-terminal.enable = true;
      tilix.enable = true;
      ghostty.enable = true;
      wezterm.enable = true;
    };
    virtualisation = {
      podman.enable = true;
      kvm.enable = true;
      # waydroid.enable = true;
      vmvariant.enable = true;
    };
    misc = {
      uad.enable = true;
      ollama.enable = true;
      aria.enable = true;
      atuin.enable = true;
      extraClis.enable = true;
      ncmpcpp.enable = true;
      yazi.enable = true;
    };
  };
}
