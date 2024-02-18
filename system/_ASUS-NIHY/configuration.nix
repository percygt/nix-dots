{
  pkgs,
  username,
  hostName,
  stateVersion,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./hyprland.nix
    ./locale.nix
    ./nvidia.nix
    ./audio.nix
  ];

  system.stateVersion = stateVersion;
  # user
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel" "audio" "libvirtd"];
  };

  # Bootloader.
  boot = {
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        extraEntries = ''
          menuentry Fedora --class fedora --class os {
            		insmod part_gpt
            		insmod ext2
              	insmod btrfs
              	insmod fat
              	search --no-floppy --fs-uuid --set=root 39E8-B8B7
              	chainloader /EFI/fedora/grubx64.efi
              }
        '';
      };
      efi = {
        efiSysMountPoint = "/boot/efi";
        canTouchEfiVariables = true;
      };
    };
  };

  #swap
  zramSwap.enable = true;

  # network
  networking = {
    inherit hostName;
    networkmanager.enable = true;
  };

  # bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings.General.Experimental = true; # for gnome-bluetooth percentage
  };

  # virtualisation
  virtualisation = {
    podman.enable = true;
    libvirtd.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # packages
  environment.systemPackages = with pkgs; [
    wget
    git
    foot
    waybar.overrideAttrs
    (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
    })
  ];

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

}
