#!/usr/bin/env python3
import subprocess
import json
import sys
import traceback
import argparse
import re

# Define the command to be executed


# Run the first command to get the output from emacsclient
def tofi(prompt: str, choices: list):
    r = subprocess.run(
        ["tofi", "--prompt-text", prompt],
        input="\n".join(choices),
        capture_output=True,
        text=True,
    ).stdout[:-1]
    if r == "":
        exit()
    return r


def get_value_by_name(data: dict, target_name: str):
    # Iterate over the dictionary and find the entry with the matching 'name'
    for category in data.values():
        if category["name"] == target_name:
            return category["value"]
    return None  # Return None if no match found


def isUrl(string):
    # findall() has been used
    # with valid conditions for urls in string
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

    args = parser.parse_args(argv)
    result = subprocess.run(
        ["emacsclient", "-e", "(+org-capture/templates-json)"],
        capture_output=True,
        text=True,
        check=True,
    )
    clipboard = subprocess.run(
        ["wl-paste"],
        capture_output=True,
        text=True,
        check=True,
    )

    emacs_output = json.loads(json.loads(result.stdout))

    top_selected_name = tofi(
        "Select the type capture template: ",
        [category["name"] for category in emacs_output.values()],
    )
    selected_name_values = [
        category["value"]
        for category in emacs_output.values()
        if category["name"] == top_selected_name
    ]

    filter_names = (
        [category["name"] for category in selected_name_values[0]]
        if isUrl(clipboard.stdout)
        else [
            category["name"]
            for category in selected_name_values[0]
            if "url" not in category["name"].lower()
        ]
    )

    final_selected_name = tofi("Select the capture template: ", filter_names)

    final_names_key = [
        category["key"]
        for category in selected_name_values[0]
        if category["name"] == final_selected_name
    ]
    emacs_cmd = (
        "org-protocol://capture?"
        + ("url" if isUrl(clipboard.stdout) else "body")
        + "="
        + clipboard.stdout
        + "&template="
        + final_names_key[0]
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
