{
  startup = [
    {
      command = "systemctl --user restart kanshi";
      always = true;
    }
    {command = "systemctl --user start wlsunset.service";}
    {command = "autotiling";}
    {command = "foot --server";}
    {
      command = "inactive-windows-transparency.py --opacity 0.85";
      always = true;
    }
  ];
}
