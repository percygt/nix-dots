{
  modules.desktop.sway.floatingRules = [
    {
      command = ''resize set width 80ppt height 80ppt, move position center'';
      criterias = [ { app_id = "chrome-app.zoom.us__wc-WebApp-zoom"; } ];
    }
  ];

  programs.chromium.webapps.zoom = {
    enable = true;
    url = "https://app.zoom.us/wc";
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
