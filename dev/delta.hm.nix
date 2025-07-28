{
  programs.git.delta = {
    enable = true;
    options = {
      chameleon = {
        blame-code-style = "syntax";
        blame-format = "{author:<18} ({commit:>7}) {timestamp:^12} ";
        blame-palette = "#2E3440 #3B4252 #434C5E #4C566A";
        dark = true;
        file-added-label = "[+]";
        file-copied-label = "[==]";
        file-decoration-style = "#434C5E ul";
        file-modified-label = "[*]";
        file-removed-label = "[-]";
        file-renamed-label = "[->]";
        file-style = "#434C5E bold";
        hunk-header-style = "omit";
        keep-plus-minus-markers = true;
        line-numbers = true;
        line-numbers-left-format = " {nm:>1} │";
        line-numbers-left-style = "red";
        line-numbers-minus-style = "red italic black";
        line-numbers-plus-style = "green italic black";
        line-numbers-right-format = " {np:>1} │";
        line-numbers-right-style = "green";
        line-numbers-zero-style = "#434C5E italic";
        minus-emph-style = "bold red";
        minus-style = "bold red";
        plus-emph-style = "bold green";
        plus-style = "bold green";
        side-by-side = true;
        syntax-theme = "Visual Studio Dark+";
        zero-style = "syntax";
      };
      features = "chameleon";
      side-by-side = true;
    };
  };
}
