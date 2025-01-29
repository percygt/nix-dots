#!/usr/bin/env bb

(require '[babashka.process :as p])

(p/sh ["notify-send" "Webpage"])
