-- @ TimescaleDB
-- get average temperature over a time buckets of 5 minutes
SELECT time_bucket('5 minutes', time) AS five_min, round(avg(temperature), 2)
FROM api_measurement
WHERE fk_measurement_station_id = 1
GROUP BY five_min
ORDER BY five_min
LIMIT 12;
