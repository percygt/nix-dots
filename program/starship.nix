{lib, ...}: let
  lang = icon: color: {
    symbol = icon;
    format = "via [$symbol $version](${color}) ";
  };
in {
  programs.starship = {
    enable = true;
    enableTransience = true;
    settings = {
      line_break = {
        disabled = true;
      };
      fill = {
        symbol = " ";
      };
      format = lib.strings.concatStrings [
        "$all"
        "$fill"
        "$shlvl"
        "$os"
        " "
        "$hostname"
        " [|](red) "
        "$shell"
        " [|](red) "
        "$time"
        "\n$container$character"
      ];
      status = {
        symbol = "✗";
        not_found_symbol = "󰍉 Not Found";
        not_executable_symbol = " Can't Execute E";
        sigint_symbol = "󰂭 ";
        signal_symbol = "󱑽 ";
        success_symbol = "";
        format = "[$symbol](fg:red) ";
        map_symbol = true;
        disabled = false;
      };
      time = {
        disabled = false;
        use_12hr = true;
        style = "yellow dimmed";
        format = "[$time]($style) ";
        time_format = "%I:%M:%S";
      };
      hostname = {
        ssh_only = false;
        style = "white";
        format = "[$ssh_symbol$hostname]($style) ";
        disabled = false;
      };
      cmd_duration = {
        min_time = 1000;
        format = "[󰔛 $duration]($style) ";
        disabled = false;
      };
      character = {
        success_symbol = "[>](bold green) ";
        error_symbol = "[>](bold red)";
      };
      container = {
        symbol = "󰮄 ";
        format = "[$symbol]($style) ";
      };
      # directory.substitutions = {
      #   "Documents" = "󰈙 ";
      #   "Downloads" = " ";
      #   "Music" = " ";
      #   "Pictures" = " ";
      #   "Videos" = " ";
      #   "GitHub" = "";
      #   ".config" = " ";
      #   "Vault" = "󱉽 ";
      # };
      git_branch = {
        symbol = "";
        format = "[$symbol $branch](fg:purple)(:$remote_branch) ";
      };
      git_status = {
        deleted = "✗";
        modified = "✶";
        staged = "✓";
        stashed = "≡";
      };
      os = {
        disabled = false;
        format = "$symbol";
      };
      os.symbols = {
        Arch = "[ ](fg:bright-blue)";
        Debian = "[ ](fg:red)";
        EndeavourOS = "[ ](fg:purple)";
        Fedora = "[ ](fg:bright-blue)";
        NixOS = "[ ](fg:white)";
        openSUSE = "[ ](fg:green)";
        SUSE = "[ ](fg:green)";
        Ubuntu = "[ ](fg:bright-red)";
      };
      shell = {
        format = "[$indicator]($style)";
        fish_indicator = "fish";
        bash_indicator = "bash";
        style = "yellow";
        disabled = false;
      };
      nix_shell = {
        disabled = false;
        format = "in [ $name](fg:white) ";
        impure_msg = "";
        # heuristic = true;
      };
      package = {
        format = "is [󰏗 $version](fg:bright-blue) ";
      };
      shlvl = {
        disabled = false;
        threshold = 2;
        format = "[󰄿 $shlvl](purple) [|](red) ";
      };
      python = lang "" "yellow";
      nodejs = lang " " "yellow";
      lua = lang "󰢱" "blue";
      rust = lang "" "red";
      java = lang "" "red";
      c = lang "" "blue";
      golang = lang "" "blue";
    };
  };
}
