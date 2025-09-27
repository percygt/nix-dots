{
  services.keyd = {
    enable = true;
    keyboards = {
      # rebuildThe name is just the name of the configuration file, it does not really matter
      default = {
        ids = [ "*" ]; # what goes into the [id] section, here we select all keyboards
        # Everything but the ID section:
        settings = {
          # The main layer, if you choose to declare it in Nix
          main = {
            capslock = "overload(control, esc)";
            # space = "overloadi(space, shift, 400)";
            # space = "overload(shift, space)";
            # a = "overload(shift, a)";
            # s = "overload(alt, s)";
            # d = "overload(control, d)";
            # f = "overload(meta, f)";
            #
            # j = "overload(meta, j)";
            # k = "overload(control, k)";
            # l = "overload(alt, l)";
            # ";" = "overload(shift, ;)";

            # capslock = "tab";
            # leftalt = "escape";
            # leftshift = "noop";
            # rightalt = "backspace";
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
