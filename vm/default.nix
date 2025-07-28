{
  stateVersion,
  profile,
  username,
  pkgs,
  homeDirectory,
  ...
}:
{
  imports = [
    ./xfce.nix
  ];
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.systemPackages = with pkgs; [
    gedit
  ];
  # Home Manager
  home-manager = {
    extraSpecialArgs = {
      inherit homeDirectory;
    };
    users.${username} = {
      home.stateVersion = stateVersion;
      imports = [ ./home.nix ];
    };
  };

  home-manager.users.root.home.stateVersion = stateVersion;
  # Networking
  networking = {
    hostName = profile;
    networkmanager.enable = true;
  };
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024;
    }
  ];
  users.users.${username} = {
    isNormalUser = true;
    initialPassword = "test";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Internationalisation options
  i18n.defaultLocale = "en_US.UTF-8";

  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];
  security.sudo.wheelNeedsPassword = false;
  # Included packages here
  nixpkgs.config.allowUnfree = true;
  services.qemuGuest.enable = true;
  # For copy/paste to work
  services.spice-vdagentd.enable = true;
  # # Options for the screen
  virtualisation.vmVariant = {
    virtualisation = {
      # qemu.options = [
      #   "-vga qxl"
      #   "-display sdl"
      # ];
      qemu.options = [
        "-vga qxl"
        "-display sdl"
        # Enable copy/paste
        # https://www.kraxel.org/blog/2021/05/qemu-cut-paste/
        "-chardev qemu-vdagent,id=ch1,name=vdagent,clipboard=on"
        "-device virtio-serial-pci"
        "-device virtserialport,chardev=ch1,id=ch1,name=com.redhat.spice.0"
      ];
      sharedDirectories = {
        sharedData = {
          source = "/home/percygt/data/nix-dots";
          target = "/home/percygt/nix-dots";
        };
      };
    };
  };
  system.stateVersion = stateVersion;
}
