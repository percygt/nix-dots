#!/usr/bin/env bb

(def now (java.time.ZonedDateTime/now))
(def PH-timezone (java.time.ZoneId/of "Asia/Manila"))
(def PH-time (.withZoneSameInstant now PH-timezone))
(def pattern (java.time.format.DateTimeFormatter/ofPattern "HH"))
(def curTime (Integer/parseInt (.format PH-time pattern)))

(if (and (<= 6 curTime) (> 18 curTime))
  (do (println "🌤️"),true)
  (do (println "<span foreground='yellow' size='large'>󰖔</span>"),false))
