#!/usr/bin/env bb

(def now (java.time.ZonedDateTime/now))
(def PH-timezone (java.time.ZoneId/of "Asia/Manila"))
(def PH-time (.withZoneSameInstant now PH-timezone))
(def pattern (java.time.format.DateTimeFormatter/ofPattern "HH"))
(def curTime (Integer/parseInt (.format PH-time pattern)))

(if (and (<= 6 curTime) (> 18 curTime))
  (do (println "🌤️"),true)
  (do (println "<span foreground='yellow' size='large'>󰖔</span>"),false))
; (case (curTime)
;   0 "ok"
;   1 "󱐿"
;   2 "ok"
;   3 "ok"
;   4 "󱑂 "
;   5 "󱑃 "
;   6 "ok"
;   7 "󱑒 "
;   8 "󱑆 "
;   9 "ok"
;   10 "ok"
;   11 "󱑉"
;   12 "ok"
;   13 "ok"
;   14 "ok"
;   15 "ok"
;   16 "ok"
;   17 "ok"
;   18 "ok"
;   19 "ok"
;   20 "ok"
;   21 "ok"
;   22 "ok"
;   23 "ok"
;   24 "ok"
;   "error")
