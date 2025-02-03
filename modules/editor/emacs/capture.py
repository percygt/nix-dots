mport subprocess
import re

def get_emacs_lisp_output():
        # Run emacsclient to get the output of org-capture-templates
        #     result = subprocess.run(
                #             ['emacsclient', '-e', '(prin1 org-capture-templates)'],
                #                     capture_output=True, text=True
                #                         )
        #                             return result.stdout
        #
        #                             def preprocess_lisp_output(lisp_output):
        #                                 # 1. Strip the leading and trailing whitespaces
        #                                     lisp_output = lisp_output.strip()
        #
        #                                         # 2. Fix issues with Emacs Lisp symbols like `#("string")`
        #                                             #    Convert these into valid Python strings
        #                                                 # Example: '#(" Tasks" 0 1 ...) -> '" Tasks"'
        #                                                     lisp_output = re.sub(r'#\((.*?)\)', r'"\1"', lisp_output)
        #
        #                                                         # 3. Replace Emacs-specific symbols or forms with Python equivalents
        #                                                             # For example, `nil` becomes `None` (Python equivalent of nil)
        #                                                                 lisp_output = lisp_output.replace('nil', 'None')
        #
        #                                                                     return lisp_output
        #
        #                                                                     def parse_lisp_output(lisp_output):
        #                                                                         # Convert the cleaned-up Lisp output into a Python object
        #                                                                             try:
        #                                                                                     # Now it's more likely to be in a format Python can understand
        #                                                                                             python_object = eval(lisp_output)  # Using eval here because we've cleaned it up
        #                                                                                                     return python_object
        #                                                                                                         except (SyntaxError, ValueError) as e:
        #                                                                                                                 print("Error parsing Lisp output:", e)
        #                                                                                                                         return None
        #
        #                                                                                                                         # Capture the Emacs Lisp output
        #                                                                                                                         lisp_output = get_emacs_lisp_output()
        #
        #                                                                                                                         # Preprocess the Lisp output
        #                                                                                                                         preprocessed_output = preprocess_lisp_output(lisp_output)
        #
        #                                                                                                                         # Parse the cleaned-up Lisp output into Python data structure
        #                                                                                                                         captured_data = parse_lisp_output(preprocessed_output)
        #
        #                                                                                                                         # Now, captured_data contains the parsed structure as Python lists and dictionaries
        #                                                                                                                         if captured_data:
        #                                                                                                                             print("Captured Data:")
        #                                                                                                                                 print(captured_data)
        #                                                                                                                                 print(captured_data)

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
