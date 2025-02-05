#!/usr/bin/env python3
import subprocess
import json
from collections import defaultdict

# Define the command to be executed

# Run the first command to get the output from emacsclient
try:
    result = subprocess.run(
        ["emacsclient", "-e", "(+org-capture/templates-json)"],
        capture_output=True,
        text=True,
        check=True,
    )
    # Decode the output from ema.stcs'
    emacs_output = json.loads(json.loads(result.stdout))
    grouped_json = defaultdict(dict)
    # # Iterate over the original JSON and group by the first letter of each key
    for key, value in emacs_output.items():
        first_letter = key[0]
        grouped_json[first_letter][key] = value
    grouped_json = dict(grouped_json)
    formatted_json_str = json.dumps(grouped_json, indent=4)
    print(formatted_json_str)
    #
except subprocess.CalledProcessError as e:
    print(f"Error executing command: {e}")
    print(f"Error details: {e.stderr.decode('utf-8')}")

# def tofi(prompt, choices):
#     r = run(
#         ["tofi", "--prompt-text", prompt],
#         input="\n".join(choices),
#         capture_output=True,
#         text=True,
#     ).stdout[:-1]
#     if r == "":
#         exit()
#     return r
#
#

# if __name__ == "__main__":
#     tofi("Templates: ", ["Ha", "heu", "asas"])
