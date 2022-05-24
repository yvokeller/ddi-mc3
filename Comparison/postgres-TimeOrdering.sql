-- ### Time Ordering ###
-- @ PostgreSQL
-- time ordering --> should make a big difference between base Postgres and TimescaleDB
SELECT date_trunc('minute', time) AS minute, max(temperature)
FROM api_measurement
WHERE time > NOW() - INTERVAL '2 months' AND fk_measurement_station_id = 1
GROUP BY minute
ORDER BY minute ASC;

