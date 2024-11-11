{
  modules = {
    core = {
      battery.enable = true;
      ephemeral.enable = true;
      autoupgrade.enable = true;
    };
    driver = {
      adb.enable = true;
      bluetooth.enable = true;
      intel.enable = true;
      intel.gpu.driver = "xe";
      # nvidia.prime.enable = true;
      nvidia.bye = true;
      printer.enable = true;
    };
    dev.enable = true;
    cli.enable = true;
    security.extraPackages.enable = true;
    editor = {
      neovim.enable = true;
      emacs.enable = true;
      vscode.enable = true;
    };
    networking = {
      vpn.enable = true;
      tailscale.enable = true;
      syncthing.enable = true;
    };
    pentesting = {
      wireless.enable = true;
      malware.enable = true;
      proxies.enable = true;
      traffic.enable = true;
    };
    virtualisation = {
      docker.enable = true;
      podman.enable = true;
      kvm.enable = true;
      vmvariant.enable = true;
    };
    utility = {
      uad.enable = true;
    };
  };

}
