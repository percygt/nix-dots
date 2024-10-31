{
  config,
  pkgs,
  ...
}:
let
  t = config.modules.theme;
  c = t.colors.withHashtag;
  f = config.modules.fonts.shell;
in
{
  home.packages = with pkgs.xfce; [
    xfce4-terminal
  ];
  # xdg.configFile."xfce4/xfconf/xfce-perchannel-xml/xfce4-terminal.xml".text =
  #   let
  #     opacity = builtins.toString ((1 - t.opacity) * 100);
  #   in
  #   # xml
  #   ''
  #     <?xml version="1.0" encoding="UTF-8"?>
  #
  #     <channel name="xfce4-terminal" version="1.0">
  #       <property name="misc-menubar-default" type="bool" value="false"/>
  #       <property name="misc-borders-default" type="bool" value="false"/>
  #       <property name="font-name" type="string" value="${f.name} SemiBold ${builtins.toString f.size}"/>
  #       <property name="font-allow-bold" type="bool" value="true"/>
  #       <property name="text-blink-mode" type="string" value="TERMINAL_TEXT_BLINK_MODE_ALWAYS"/>
  #       <property name="cell-width-scale" type="double" value="1"/>
  #       <property name="background-mode" type="string" value="TERMINAL_BACKGROUND_TRANSPARENT"/>
  #       # <property name="background-darkness" type="double" value="${opacity}"/>
  #       <property name="misc-toolbar-default" type="bool" value="false"/>
  #       <property name="misc-slim-tabs" type="bool" value="true"/>
  #       <property name="color-cursor-use-default" type="bool" value="false"/>
  #       <property name="color-selection-use-default" type="bool" value="false"/>
  #       <property name="color-bold-use-default" type="bool" value="false"/>
  #       <property name="color-use-theme" type="bool" value="false"/>
  #       <property name="color-background-vary" type="bool" value="false"/>
  #       <property name="misc-cursor-shape" type="string" value="TERMINAL_CURSOR_SHAPE_BLOCK"/>
  #       <property name="misc-cursor-blinks" type="bool" value="true"/>
  #       <property name="misc-copy-on-select" type="bool" value="true"/>
  #       <property name="font-use-system" type="bool" value="false"/>
  #       <property name="overlay-scrolling" type="bool" value="true"/>
  #       <property name="color-palette" type="string" value="${c.base01};${c.base08};${c.base0B};${c.base09};${c.base0D};${c.base0E};${c.base0C};${c.base06};${c.base02};${c.base12};${c.base14};${c.base13};${c.base16};${c.base17};${c.base15};${c.base07}"/>
  #       <property name="color-foreground" type="string" value="${c.base05}"/>
  #       <property name="color-cursor-foreground" type="string" value="${c.base05}"/>
  #       <property name="color-cursor" type="string" value="${c.base05}"/>
  #       <property name="color-selection" type="string" value="${c.base02}"/>
  #       <property name="color-selection-background" type="string" value="${c.base08}"/>
  #       <property name="color-bold" type="string" value="${c.base09}"/>
  #     </channel>
  #   '';
}
