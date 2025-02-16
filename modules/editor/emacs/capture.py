import subprocess
import json
import sys
import traceback
import argparse
import logging
import re
import os
import urllib.parse

tofi_config = f"{os.getenv('XDG_CONFIG_HOME')}/tofi/config-horizontal-mid"


# Run the first command to get the output from emacsclient
def tofi(prompt: str, choices: list):
    r = subprocess.run(
        ["tofi", "--prompt-text", prompt, "--config", tofi_config],
        input="\n".join(choices),
        capture_output=True,
        text=True,
    ).stdout[:-1]
    if r == "":
        exit()
    return r


def get_value_by_name(data: dict, target_name: str):
    """Find a value in the dictionary by matching the 'name'."""
    return next(
        (
            category["value"]
            for category in data.values()
            if category["name"] == target_name
        ),
        None,
    )


def is_url(string: str):
    regex = r"(?i)\b((?:https?://|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'\".,<>?«»“”‘’]))"
    return re.match(regex, string) is not None


def main(argv=None):
    parser = argparse.ArgumentParser(description="initiate emacs org-capture")
    parser.add_argument(
        "-w",
        "--wclass",
        type=str,
        default="org-capture",
    )
    parser.add_argument(
        "-t",
        "--tofi_config",
        type=str,
    )

    args = parser.parse_args(argv)

    subprocess.run(
        f"footclient --app-id {args.wclass} --title Clipboard -- cliphist-fzf-sixel",
        shell=True,
    )

    r = subprocess.run(
        ["emacsclient", "-e", "(+org-capture/templates-json)"],
        capture_output=True,
        text=True,
        check=True,
    )

    cb = subprocess.run(
        ["wl-paste"],
        capture_output=True,
        check=True,
    ).stdout

    cb_content = ""

    try:
        cb_content = cb.decode().strip()
    except UnicodeDecodeError as e:
        logging.error(e)
    except Exception as e:
        logging.error(e)

    emacs_output = json.loads(json.loads(r.stdout))

    top_selected_name = tofi(
        "Select the type capture template: ",
        [category["name"] for category in emacs_output.values()],
    )
    selected_name_value = next(
        (
            category["value"]
            for category in emacs_output.values()
            if category["name"] == top_selected_name
        ),
    )

    is_cb_url = is_url(cb_content)

    filter_names = (
        [category["name"] for category in selected_name_value]
        if is_cb_url
        else [
            category["name"]
            for category in selected_name_value
            if "url" not in category["name"].lower()
        ]
    )

    final_selected_name = tofi(
        "Select the capture template: ",
        filter_names,
    )

    final_names_key = next(
        (
            category["key"]
            for category in selected_name_value
            if category["name"] == final_selected_name
        )
    )

    parsed_cb_text = urllib.parse.quote(cb_content)
    cb_type = "url" if is_url(cb_content) else "body"

    emacs_cmd = (
        f"org-protocol://capture?template={final_names_key}&{cb_type}={parsed_cb_text}"
    )

    subprocess.run(
        [
            "footclient",
            "--app-id",
            args.wclass,
            "--title",
            "Emacs",
            "--",
            "emacsclient",
            "-t",
            "-a",
            "''",
            emacs_cmd,
        ],
        capture_output=True,
        text=True,
        check=True,
    )


if __name__ == "__main__":
    try:
        sys.exit(main(sys.argv[1:]))
    except Exception:
        print(traceback.format_exc(), file=sys.stderr)
        sys.exit(1)
