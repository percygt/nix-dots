; Copied from https://github.com/stelcodes/nixos-config/commit/9baffbbec50d6128a18ac389f3f7c8fd5fbc7956
#!/usr/bin/env bb

(require '[babashka.process :as p])
(require '[cheshire.core :as json])
(require '[clojure.pprint :as pp])

(defmacro debug [sym] `(do (println ~(keyword sym)) (pp/pprint ~sym) (println)))

(def outputs
  (-> (p/sh ["swaymsg" "-t" "get_outputs"])
      :out
      (json/parse-string true)))

(def next-output (->> outputs
                      ;; (remove #(re-find #"bad-output" (:name %)))
                      (sort-by :id)
                      cycle
                      (reduce (fn [last-output-was-focused output]
                                (if last-output-was-focused
                                  (reduced output)
                                  (:focused output)))
                              false)))

(defn switch-output [output]
  (p/sh ["swaymsg" "focus" "output" (:name output)]))

(switch-output next-output)
