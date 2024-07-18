{
  programs.chromium.webapps.element = {
    enable = true;
    url = "https://app.element.io";
    mimeType = [ "x-scheme-handler/element" ];
    categories = [
      "Network"
      "InstantMessaging"
      "Chat"
      "VideoConference"
    ];
  };
}
