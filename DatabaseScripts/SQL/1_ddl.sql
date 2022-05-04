--
-- Create model Classroom
--
CREATE TABLE "api_classroom"
(
    "id"          serial                   NOT NULL PRIMARY KEY,
    "name"        varchar(100)             NOT NULL,
    "description" varchar(200)             NOT NULL,
    "room_number" varchar(100)             NOT NULL,
    "updated_on"  timestamp with time zone NOT NULL
);
--
-- Create model MeasurementStation
--
CREATE TABLE "api_measurementstation"
(
    "id"              serial      NOT NULL PRIMARY KEY,
    "name"            varchar(50) NOT NULL,
    "active"          boolean     NOT NULL,
    "fk_classroom_id" integer     NOT NULL
);
--
-- Create model Measurement
--
CREATE TABLE "api_measurement"
(
    "id"                        serial                   NOT NULL PRIMARY KEY,
    "time"                      timestamp with time zone NOT NULL,
    "insert_time"               timestamp with time zone NOT NULL,
    "co2"                       numeric(19, 10)          NULL,
    "temperature"               numeric(19, 10)          NULL,
    "humidity"                  numeric(19, 10)          NULL,
    "motion"                    boolean                  NULL,
    "light"                     numeric(19, 10)          NULL,
    "fk_measurement_station_id" integer                  NOT NULL
);
--
-- Create model EntranceEvent
--
CREATE TABLE "api_entranceevent"
(
    "id"                        serial                   NOT NULL PRIMARY KEY,
    "time"                      timestamp with time zone NOT NULL,
    "change"                    integer                  NOT NULL,
    "insert_time"               timestamp with time zone NOT NULL,
    "fk_measurement_station_id" integer                  NOT NULL
);