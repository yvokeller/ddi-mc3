-- overview: https://docs.timescale.com/timescaledb/latest/how-to-guides/query-data/advanced-analytic-queries/#histogram
-- performance difference: https://www.timescale.com/blog/timescaledb-vs-6a696248104e/

-- @ PostgreSQL & TimescaleDB
-- get median temperature for a measurement station
SELECT percentile_cont(0.5)
       WITHIN GROUP (ORDER BY temperature)
FROM smartclassroom_dev.public.api_measurement
WHERE fk_measurement_station_id = 1;

-- @ PostgreSQL & TimescaleDB
-- moving average
SELECT time,
       AVG(temperature) OVER (ORDER BY time ROWS BETWEEN 9 PRECEDING AND CURRENT ROW)
           AS smooth_temp
FROM smartclassroom_dev.public.api_measurement
WHERE fk_measurement_station_id = 1
  and time > NOW() - INTERVAL '1 day'
ORDER BY time DESC;

-- @ PostgreSQL & TimescaleDB
-- delta values - only get values that have changed in result set
SELECT time, temperature
FROM (
         SELECT time,
                temperature,
                temperature - LAG(temperature) OVER (ORDER BY time) AS diff
         FROM smartclassroom_dev.public.api_measurement
         WHERE fk_measurement_station_id = 1) ht
WHERE diff IS NULL
   OR diff != 0;

-- ### Time Ordering ###
-- @ PostgreSQL & TimescaleDB
-- time ordering --> should make a big difference between base Postgres and TimescaleDB
SELECT date_trunc('minute', time) AS minute, max(temperature)
FROM smartclassroom_dev.public.api_measurement
WHERE time > NOW() - INTERVAL '14 days' AND fk_measurement_station_id = 1
GROUP BY minute
ORDER BY minute ASC;

-- ### Time Bucketing ###
-- @ PostgreSQL

-- You can generate a table of "buckets" by adding intervals created by generate_series(). 
-- This SQL statement will generate a table of five-minute buckets for the first day (the value of min(measured_at)) in your data.

select 
  (select min(measured_at)::date from measurements) + ( n    || ' minutes')::interval start_time,
  (select min(measured_at)::date from measurements) + ((n+5) || ' minutes')::interval end_time
from generate_series(0, (24*60), 5) n;

 -- Wrap that statement in a common table expression, and you can join and group on it as if it were a base table.

with five_min_intervals as (
  select 
    (select min(time)::date from api_measurement) + ( n    || ' minutes')::interval start_time,
    (select min(time)::date from api_measurement) + ((n+5) || ' minutes')::interval end_time
  from generate_series(0, (24*60), 5) n
)
select f.start_time, f.end_time, sum(m.temperature) avg_val
from api_measurement m
right join five_min_intervals f 
        on m.time >= f.start_time and m.time < f.end_time
group by f.start_time, f.end_time
order by f.start_time;

-- @ TimescaleDB
-- get average temperature over a time buckets of 5 minutes
SELECT time_bucket('5 minutes', time) AS five_min, round(avg(temperature), 2)
FROM smartclassroom_dev.public.api_measurement
WHERE fk_measurement_station_id = 1
GROUP BY five_min
ORDER BY five_min DESC
LIMIT 100;

-- ### Histogram ###
-- histogram - get temperature values in 8 bins between 15°C and 35°C, which makes a bin range of 2.5°C
SELECT ms.name,
       COUNT(*),
       histogram(m.temperature, 15.0, 35.0, 8)
FROM smartclassroom_dev.public.api_measurement m
         INNER JOIN smartclassroom_dev.public.api_measurementstation ms ON m.fk_measurement_station_id = ms.id
WHERE time > NOW() - INTERVAL '14 days'
GROUP BY ms.name;

-- ### Time Weighted Average ###
-- how do we get a representative average when we’re working with irregularly spaced data points?
-- https://www.timescale.com/blog/what-time-weighted-averages-are-and-why-you-should-care/
SELECT freezer_id, 
	avg(temperature), 
	average(time_weight('Linear', ts, temperature)) as time_weighted_average 
FROM freezer_temps
GROUP BY freezer_id;
