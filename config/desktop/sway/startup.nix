{
  startup = [
    {
      command = "systemctl --user restart kanshi";
      always = true;
    }
    { command = "systemctl --user start wlsunset.service"; }
    { command = "autotiling"; }
    { command = "foot --server"; }
  ];
}
