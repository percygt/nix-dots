#!/usr/bin/env python3
from subprocess import run

# from argparse import ArgumentParser
#
# parser = ArgumentParser(description="Emacs org capture helper.")
#
# parser.add_argument("-n", "--name", dest="name", required=True, help="sample")
# args = parser.parse_args()
r = run(
    ["emacsclient", "--eval", "(+org-capture/templates-json)"],
    capture_output=True,
    text=True,
)

print(r.stdout)
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
