WITH rides AS (
  SELECT
    DATE(starttime) AS ride_date,
    COUNT(*) AS num_rides,
    ROUND(AVG(tripduration) / 60.0, 2) AS avg_duration_min
  FROM `bigquery-public-data.new_york_citibike.citibike_trips`
  WHERE starttime IS NOT NULL
  GROUP BY ride_date
),

weather AS (
  SELECT
    PARSE_DATE('%Y-%m-%d', CONCAT(year, '-', mo, '-', da)) AS obs_date,
    temp AS temp_f,
    `max` AS max_temp_f,
    `min` AS min_temp_f,
    CAST(wdsp AS FLOAT64) AS wind_speed_knots,
    prcp AS precip_in
  FROM `bigquery-public-data.noaa_gsod.gsod20*`
  WHERE _TABLE_SUFFIX BETWEEN '13' AND '18'
    AND stn = '725030'
)

SELECT
  r.ride_date,
  r.num_rides,
  r.avg_duration_min,
  w.temp_f,
  w.max_temp_f,
  w.min_temp_f,
  w.wind_speed_knots,
  w.precip_in
FROM rides r
INNER JOIN weather w
  ON r.ride_date = w.obs_date
ORDER BY r.ride_date;
