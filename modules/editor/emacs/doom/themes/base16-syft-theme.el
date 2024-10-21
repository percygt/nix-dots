;; base16-syft-theme.el -- A base16 colorscheme

;;; Commentary:
;; Base16: (https://github.com/tinted-theming/home)

;;; Authors:
;; Scheme: TheNeverMan (github.com/TheNeverMan)
;; Template: Kaleb Elwert <belak@coded.io>

;;; Code:

(require 'base16-theme)

(defvar base16-syft-theme-colors
  '(:base00 "#101600"
    :base01 "#1a1e01"
    :base02 "#242604"
    :base03 "#2e2e05"
    :base04 "#ffd129"
    :base05 "#ffda51"
    :base06 "#ffe178"
    :base07 "#ffeba0"
    :base08 "#ee2e00"
    :base09 "#ee8800"
    :base0A "#eebb00"
    :base0B "#63d932"
    :base0C "#3d94a5"
    :base0D "#5b4a9f"
    :base0E "#883e9f"
    :base0F "#a928b9")
  "All colors for Base16 Syft are defined here.")

;; Define the theme
(deftheme base16-syft)

;; Add all the faces to the theme
(base16-theme-define 'base16-syft base16-syft-theme-colors)

;; Mark the theme as provided
(provide-theme 'base16-syft)

(provide 'base16-syft-theme)

;;; base16-syft-theme.el ends here
