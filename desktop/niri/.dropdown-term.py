#!/usr/bin/env python3

import argparse
import subprocess
import sys
import time
import shlex
from typing import Optional


def notify(*args, urgency=None):
    cmd = ["notify-send"]
    if urgency:
        cmd += ["-u", urgency]
    cmd += list(args)
    subprocess.run(cmd, check=False)
    print(" ".join(args))


def get_json_output(cmd: str):
    try:
        output = subprocess.check_output(shlex.split(cmd), text=True)
        return output
    except subprocess.CalledProcessError:
        return ""


def wait_online():
    for _ in range(200):
        try:
            subprocess.check_output(
                ["ping", "-qc", "1", "github.com"], stderr=subprocess.DEVNULL
            )
            return
        except subprocess.CalledProcessError:
            time.sleep(0.1)


def partial_match(query: str) -> Optional[str]:
    cmd = "niri msg --json windows"
    try:
        out = subprocess.check_output(shlex.split(cmd))
        jq_cmd = f'.[] | select((.app_id | match("{query}"; "i"))) | .app_id'
        result = subprocess.run(
            ["jq", "-r", jq_cmd], input=out, capture_output=True, text=True
        )
        return result.stdout.strip().split("\n")[0]
    except Exception:
        return None


def main():
    parser = argparse.ArgumentParser(
        description="ndrop - Smart application window focus/launch utility",
        add_help=False,
    )
    parser.add_argument(
        "-c", "--class", dest="class_override", help="Set classname for matching"
    )
    parser.add_argument(
        "-F", "--focus", action="store_true", help="Focus instead of hiding window"
    )
    parser.add_argument("-H", "--help", action="store_true", help="Print help message")
    parser.add_argument(
        "-i",
        "--insensitive",
        action="store_true",
        help="Case-insensitive class matching",
    )
    parser.add_argument(
        "-o", "--online", action="store_true", help="Wait for internet before launching"
    )
    parser.add_argument(
        "-v", "--verbose", action="store_true", help="Show verbose notifications"
    )
    parser.add_argument("command", nargs=argparse.REMAINDER)

    args = parser.parse_args()

    if args.help:
        parser.print_help()
        sys.exit(0)

    if not args.command:
        notify("ndrop: Missing Argument", "Run 'ndrop -h' for more information")
        parser.print_help()
        sys.exit(1)

    command = args.command
    program = command[0]
    class_name = program

    # Hardcoded replacements
    hardcoded_classes = {
        "epiphany": "org.gnome.Epiphany",
        "brave": "brave-browser",
        "logseq": "Logseq",
        "telegram-desktop": "org.telegram.desktop",
        "tor-browser": "Tor Browser",
    }

    if program in hardcoded_classes:
        class_name = hardcoded_classes[program]
    elif program == "godot4":
        matched = partial_match("org.godotengine.")
        if matched:
            class_name = matched

    if args.class_override:
        if args.verbose:
            notify(
                f"ndrop: --class -> Using given class '{args.class_override}' instead of '{class_name}'",
                urgency="low",
            )
        class_name = args.class_override

    if args.insensitive:
        found = get_json_output(
            'niri msg --json windows | jq -r \'.[] | select((.app_id | test("{}"; "i")))\''.format(
                class_name
            )
        )
        if found:
            matched = partial_match(class_name)
            if matched:
                if args.verbose:
                    notify(
                        f"ndrop: --insensitive -> Using class '{matched}' after partial match",
                        urgency="low",
                    )
                class_name = matched

    # Get active workspace and index
    try:
        active_workspace = subprocess.check_output(
            "niri msg --json workspaces | jq -r '.[] | select(.is_focused==true) | .id'",
            shell=True,
            text=True,
        ).strip()

        active_workspace_idx = subprocess.check_output(
            "niri msg --json workspaces | jq -r '.[] | select(.is_focused==true) | .idx'",
            shell=True,
            text=True,
        ).strip()
    except subprocess.CalledProcessError:
        notify(
            "ndrop: Error getting active workspace",
            f"Check terminal output of 'ndrop {' '.join(command)}'",
        )
        sys.exit(1)

    windows_json = get_json_output("niri msg --json windows")
    try:
        all_windows = (
            subprocess.run(
                ["jq", "-r", ".[] | [.app_id, .id, .workspace_id] | @tsv"],
                input=windows_json,
                capture_output=True,
                text=True,
            )
            .stdout.strip()
            .split("\n")
        )
    except Exception:
        all_windows = []

    matched_window = None
    for line in all_windows:
        app_id, win_id, workspace_id = line.strip().split("\t")
        if app_id == class_name:
            matched_window = (win_id, workspace_id)
            break

    if matched_window:
        win_id, workspace_id = matched_window
        if workspace_id != active_workspace:
            if not args.focus:
                subprocess.run(
                    [
                        "niri",
                        "msg",
                        "action",
                        "move-window-to-workspace",
                        "--window-id",
                        win_id,
                        active_workspace_idx,
                    ]
                )
                if args.verbose:
                    notify(
                        f"ndrop: Moved class '{class_name}' to current workspace",
                        urgency="low",
                    )
            subprocess.run(["niri", "msg", "action", "focus-window", "--id", win_id])
        else:
            if not args.focus:
                subprocess.run(
                    [
                        "niri",
                        "msg",
                        "action",
                        "move-window-to-workspace",
                        "--focus",
                        "false",
                        "--window-id",
                        win_id,
                        "ndrop",
                    ]
                )
                if args.verbose:
                    notify(
                        f"ndrop: Moved class '{class_name}' to workspace 'ndrop'",
                        urgency="low",
                    )
            else:
                subprocess.run(
                    ["niri", "msg", "action", "focus-window", "--id", win_id]
                )
    else:
        if args.online:
            wait_online()

        try:
            subprocess.Popen(command)
        except Exception:
            notify("ndrop: Error executing given command", " ".join(command))

        if args.verbose:
            current_classes = subprocess.check_output(
                "niri msg --json windows | jq -r '.[] | .app_id' | sort | tr '\\n' ' '",
                shell=True,
                text=True,
            ).strip()
            notify(
                f"ndrop: No running program matches class '{class_name}'.",
                f"Currently active classes: {current_classes}. Executed: {' '.join(command)}",
                urgency="low",
            )


if __name__ == "__main__":
    main()
