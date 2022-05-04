-- classroom
INSERT INTO public.api_classroom
(id,
 name,
 description,
 room_number,
 updated_on)
VALUES (0,
        '1.010',
        'Lichthof',
        '1.010',
        NOW());

-- measurement station
INSERT INTO public.api_measurementstation(id, name, active, fk_classroom_id)
VALUES (1, 'Raspberry Pi', true, 0);

-- random api_measurement data
INSERT INTO public.api_measurement (time,
                                    fk_measurement_station_id,
                                    co2,
                                    temperature,
                                    humidity,
                                    insert_time,
                                    light,
                                    motion)
SELECT time,
       1,
       round(random() * (1500 - 500) + 500)  AS co2,
       round(random() * (23 - 17) + 17)      AS temperature,
       round(random() * (90 - 20) + 20)      AS humidity,
       NOW(),
       round(random() * (40000 - 200) + 200) AS light,
       random() > 0.5                        AS motion
FROM generate_series('2022-01-01'::date
         , '2022-04-15'::date
         , '1 second'::interval) AS time;

-- random entrance events
INSERT INTO public.api_entranceevent(time, change, insert_time, fk_measurement_station_id)
SELECT time,
       round(random() * (-1 - 1) + 1) AS change,
       NOW() AS insert_time,
       1 AS fk_measurement_station_id
FROM generate_series('2022-01-01'::date
         , '2022-04-15'::date
         , '1 second'::interval) AS time;