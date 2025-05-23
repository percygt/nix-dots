import subprocess
import json
import sys
import argparse
import logging
import re
import os
import traceback
import urllib.parse


def get_args():
    parser = argparse.ArgumentParser(description="initiate emacs org-capture")
    parser.add_argument(
        "-c",
        "--clipboard",
        type=str,
    )
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

    return parser.parse_args()


def tofi_run(prompt: str, choices: list) -> str:
    """Runs tofi with the given prompt and choices."""
    tofi_config = f"{os.getenv('XDG_CONFIG_HOME')}/tofi/config-horizontal-mid"
    try:
        result = subprocess.run(
            ["tofi", "--prompt-text", prompt, "--config", tofi_config],
            input="\n".join(choices),
            capture_output=True,
            text=True,
            check=True,
        )
        output = result.stdout.strip()
        if not output:
            sys.exit(0)  # Exit gracefully if no selection
        return output
    except subprocess.CalledProcessError as e:
        print(f"Error running tofi: {e}", file=sys.stderr)
        sys.exit(1)


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


def get_capture_data():
    r = subprocess.run(
        ["emacsclient", "-e", "(+org-capture/templates-json)"],
        capture_output=True,
        text=True,
        check=True,
    )
    return json.loads(json.loads(r.stdout))


def combine_all_values():
    """Combine all 'value' lists from the dictionary."""
    combined_values = []
    for category in get_capture_data().values():
        if "value" in category:
            combined_values.extend(category["value"])
    return combined_values


def all_templates():
    """Extract the 'name' field from each entry in the combined values list."""
    combined_values = combine_all_values()
    return [category["name"] for category in combined_values]


def clipboard_templates():
    return [name for name in all_templates() if "url" in name or "text/link" in name]


def url_templates():
    return [name for name in all_templates() if "url" in name]


def default_templates():
    return [
        name for name in all_templates() if "url" not in name or "text/link" not in name
    ]


def main():
    args = get_args()
    subprocess.run(
        f"footclient --app-id {args.wclass} --title Clipboard -- cliphist-fzf",
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

    top_selected_name = tofi_run(
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

    final_selected_name = tofi_run(
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
        sys.exit(main())
    except Exception:
        print(traceback.format_exc(), file=sys.stderr)
        sys.exit(1)
