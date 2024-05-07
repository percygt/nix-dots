{pkgs, ...}: {
  programs.firefox.webapps.zoom = {
    enable = true;

    url = "https://us04web.zoom.us/myhome";
    id = 2;

    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      zoom-redirector
    ];

    backgroundColor = "#202225";

    comment = "Zoom Video Conference";
    genericName = "Zoom Client";
    categories = [
      "Network"
      "InstantMessaging"
      "VideoConference"
      "Telephony"
    ];
  };
}
