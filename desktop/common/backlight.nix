{
  config,
  username,
  pkgs,
  lib,
  ...
}:
{
  hardware.i2c.enable = true;
  users.users."${username}".extraGroups = [ "i2c" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];
  boot.kernelModules = [ "ddcci_backlight" ];
  environment.systemPackages = with pkgs; [
    ddcutil
    brightnessctl
  ];
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="i2c-dev", TAG+="ddcci", TAG+="systemd", ENV{SYSTEMD_WANTS}+="ddcci@$kernel.service"
  '';

  systemd.services."ddcci@" = {
    description = "Force DDC/CI device detection";
    scriptArgs = "%i";
    script = ''
      echo "Trying to force DDC/CI device detection for $1."
      id=$(echo "$1" | cut -d "-" -f 2)
      for i in {1..5}; do
        echo "Attempt $i..."
        if ${lib.getExe pkgs.ddcutil} --disable-dynamic-sleep getvcp 10 -b "$id"; then
          echo ddcci 0x37 > /sys/bus/i2c/devices/$1/new_device
          echo Success!
          break
        fi
      done
    '';
    serviceConfig.Type = "oneshot";
  };
}
