{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    package = pkgs.stash.firefox.override {nativeMessagingHosts = [pkgs.tridactyl-native];};
    profiles."home" = {
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        aria2-integration
        buster-captcha-solver
        clearurls
        decentraleyes
        indie-wiki-buddy
        keepassxc-browser
        libredirect
        no-pdf-download
        tridactyl
        ublock-origin
        zoom-redirector
      ];
    };
  };
}
