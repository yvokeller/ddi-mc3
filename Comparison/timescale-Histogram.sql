-- ### Histogram ###
-- histogram - get temperature values in 8 bins between 15°C and 35°C, which makes a bin range of 2.5°C
SELECT ms.name,COUNT(*),histogram(m.temperature, 15.0, 35.0, 8) FROM api_measurement m
INNER JOIN api_measurementstation ms ON m.fk_measurement_station_id = ms.id
WHERE time > NOW() - INTERVAL '2 months'
GROUP BY ms.name;

