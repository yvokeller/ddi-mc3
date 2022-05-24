-- ### Time Bucketing ###
-- @ PostgreSQL

SELECT generate_series(0, (1*55), 5);

-- We can generate a table of "buckets" by adding intervals created by generate_series().
-- This SQL statement will generate a table of five-minute buckets
-- for the first day (the value of min(measured_at)) in our data.
select
  (select min(time)::date from api_measurement) + ( n    || ' minutes')::interval start_time,
  (select min(time)::date from api_measurement) + ((n+5) || ' minutes')::interval end_time
from generate_series(0, (24*55), 5) n;

 -- We wrap that statement in a common table expression, and we can join and group on it as if it were a base table.
with five_min_intervals as (
  select
    (select min(time)::date from api_measurement) + ( n    || ' minutes')::interval start_time,
    (select min(time)::date from api_measurement) + ((n+5) || ' minutes')::interval end_time
  from generate_series(0, (1*55), 5) n
)
select f.start_time, round(avg(m.temperature), 2) avg_val
from api_measurement m
right join five_min_intervals f
        on m.time >= f.start_time and m.time < f.end_time
where fk_measurement_station_id = 1
group by f.start_time, f.end_time
order by f.start_time;