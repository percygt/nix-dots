{
  programs.brave-nightly = {
    enable = false;
    commandLineArgs = [
      "--password-store=basic"
    ];
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
    ];
  };
}
