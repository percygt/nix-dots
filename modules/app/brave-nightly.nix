{
  programs.brave-nightly = {
    enable = true;
    commandLineArgs = [
      "--password-store=basic"
    ];
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
    ];
  };
}
