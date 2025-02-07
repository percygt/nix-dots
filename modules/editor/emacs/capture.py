#!/usr/bin/env python3
import subprocess
import json
import sys
import traceback
import argparse
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


def main(argv=None):
    parser = argparse.ArgumentParser(description="initiate emacs org-capture")
    parser.add_argument("-C", "--clipboard-params", metavar="clipboard-params")
    args = parser.parse_args(argv)
    result = subprocess.run(
        ["emacsclient", "-e", "(+org-capture/templates-json)"],
        capture_output=True,
        text=True,
        check=True,
    )
    emacs_output = json.loads(json.loads(result.stdout))
    top_level_names = [category["name"] for category in emacs_output.values()]
    selected_top_name = tofi("Select the type capture template: ", top_level_names)
    # values = get_value_by_name(emacs_output, selected_top_name)
    values = [
        category["value"]
        for category in emacs_output.values()
        if category["name"] == selected_top_name
    ]
    second_level_names = [category["name"] for category in values[0]]
    second = tofi("Select the capture template: ", second_level_names)
    key = [category["key"] for category in values[0] if category["name"] == second]

    clipboard = subprocess.run(
        ["wl-paste"],
        capture_output=True,
        text=True,
        check=True,
    )
    emacs_cmd = (
        "org-protocol://capture?url='" + clipboard.stdout + "'&template=" + key[0]
    )
    subprocess.run(
        [
            "footclient",
            "--app-id",
            "org-capture",
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
