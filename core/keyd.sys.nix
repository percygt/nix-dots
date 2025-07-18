{
  services.keyd = {
    enable = true;
    keyboards = {
      # The name is just the name of the configuration file, it does not really matter
      default = {
        ids = [ "*" ]; # what goes into the [id] section, here we select all keyboards
        # Everything but the ID section:
        settings = {
          # The main layer, if you choose to declare it in Nix
          main = {
            capslock = "overload(control, esc)";
            # space = "overloadi(space, shift, 400)";
            # space = "lettermod(shift, space, 150, 200)";
            a = "lettermod(shift, a, 150, 200)";
            s = "lettermod(alt, s, 150, 200)";
            d = "lettermod(control, d, 150, 200)";
            f = "lettermod(meta, f, 150, 200)";

            j = "lettermod(meta, j, 150, 200)";
            k = "lettermod(control, k, 150, 200)";
            l = "lettermod(alt, l, 150, 200)";
            ";" = "lettermod(shift, ;, 150, 200)";

            # capslock = "tab";
            leftalt = "escape";
            # leftshift = "noop";
            rightalt = "backspace";
            # tab = "noop";
          };
          #   otherlayer = { };
        };
        # extraConfig = ''
        #   # put here any extra-config, e.g. you can copy/paste here directly a configuration, just remove the ids part
        # '';
      };
    };
  };
  # Optional, but makes sure that when you type the make palm rejection work with keyd
  # https://github.com/rvaiya/keyd/issues/723
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal
  '';
}
