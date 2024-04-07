{desktop, ...}: {
  imports = [
    (
      if desktop == null
      then ./gnome
      else ./${desktop}
    )
  ];
}
