{
  modules.desktop.sway.floatingRules = [
    {
      command = ''resize set width 80ppt height 80ppt, move position center'';
      criterias = [ { app_id = "chrome-chatgpt.com__-WebApp-ai"; } ];
    }
  ];

  programs.chromium.webapps.ai = {
    enable = true;
    url = "https://chatgpt.com";
    comment = "ChatGPT: Get instant answers, find inspiration, learn something new";
    genericName = "ChatGPT";
    categories = [ "Network" ];
  };
}
