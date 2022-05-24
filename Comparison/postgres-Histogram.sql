-- ### Histogram ###
-- histogram - get temperature values in bins with a range of 2.5°C, empty bins are missing in the output
select floor(temperature/2.5)*2.5 as bin, count(*)
FROM api_measurement m
INNER JOIN api_measurementstation ms ON m.fk_measurement_station_id = ms.id
WHERE time > NOW() - INTERVAL '2 months'
     group by 1
     order by 1;

-- histogram - get temperature values in bins with a range of 2.5°C, values have to be set manually so empty bins have to be made manually as well
select '15-17.5' as bin,count(temperature) as Count from api_measurement m
     INNER JOIN api_measurementstation ms ON m.fk_measurement_station_id = ms.id
        WHERE time > NOW() - INTERVAL '2 months' and temperature between 15 and 17.5
     union (
     select '17.5-20' as bin,count(temperature) as Count from api_measurement m
     INNER JOIN api_measurementstation ms ON m.fk_measurement_station_id = ms.id
        WHERE time > NOW() - INTERVAL '2 months' and
         temperature between 17.5 and 20)
     union (
     select '20-22.5' as bin,count(temperature) as Count from api_measurement m
     INNER JOIN api_measurementstation ms ON m.fk_measurement_station_id = ms.id
        WHERE time > NOW() - INTERVAL '2 months' and temperature between 20 and 22.5)
     union (
     select '22.5-25' as bin,count(temperature) as Count from api_measurement m
     INNER JOIN api_measurementstation ms ON m.fk_measurement_station_id = ms.id
        WHERE time > NOW() - INTERVAL '2 months' and temperature between 22.5 and 25);