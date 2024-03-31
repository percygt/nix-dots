{desktop, ...}: {
  imports = [
    (
      if desktop
      then "./${desktop}"
      else "./gnome"
    )
  ];
}
