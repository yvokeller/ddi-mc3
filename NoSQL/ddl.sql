--
-- Create database
--
CREATE DATABASE smartclassroom_ddl;

--
-- DDL - Make sure you are in correct schema before executing!
--
BEGIN;
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
DO
$do$
    BEGIN
        IF EXISTS(SELECT * FROM timescaledb_information.hypertables WHERE hypertable_name = 'api_measurement') THEN
            RAISE EXCEPTION 'assert failed - ''api_measurement'' should not be a hyper table';
        ELSE
            NULL;
        END IF;
    END;
$do$;
ALTER TABLE "api_measurement"
    DROP CONSTRAINT "api_measurement_pkey";
SELECT create_hypertable('api_measurement', 'time', chunk_time_interval => interval '1 day', migrate_data => false);
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
DO
$do$
    BEGIN
        IF EXISTS(SELECT * FROM timescaledb_information.hypertables WHERE hypertable_name = 'api_entranceevent') THEN
            RAISE EXCEPTION 'assert failed - ''api_entranceevent'' should not be a hyper table';
        ELSE
            NULL;
        END IF;
    END;
$do$;
ALTER TABLE "api_entranceevent"
    DROP CONSTRAINT "api_entranceevent_pkey";
SELECT create_hypertable('api_entranceevent', 'time', chunk_time_interval => interval '1 day', migrate_data => false);
--
-- Create model ConnectionHistory
--
CREATE TABLE "api_connectionhistory"
(
    "id"                        serial                   NOT NULL PRIMARY KEY,
    "time"                      timestamp with time zone NOT NULL,
    "insert_time"               timestamp with time zone NOT NULL,
    "ip_address"                inet                     NOT NULL,
    "bluetooth_connected"       boolean                  NULL,
    "wlan_signal_strength"      integer                  NOT NULL,
    "ping_backend"              integer                  NOT NULL,
    "ping_broker"               integer                  NOT NULL,
    "ping_grafana"              integer                  NOT NULL,
    "fk_measurement_station_id" integer                  NOT NULL
);
DO
$do$
    BEGIN
        IF EXISTS(SELECT *
                  FROM timescaledb_information.hypertables
                  WHERE hypertable_name = 'api_connectionhistory') THEN
            RAISE EXCEPTION 'assert failed - ''api_connectionhistory'' should not be a hyper table';
        ELSE
            NULL;
        END IF;
    END;
$do$;
ALTER TABLE "api_connectionhistory"
    DROP CONSTRAINT "api_connectionhistory_pkey";
SELECT create_hypertable('api_connectionhistory', 'time', chunk_time_interval => interval '1 day',
                         migrate_data => false);
ALTER TABLE "api_measurementstation"
    ADD CONSTRAINT "api_measurementstati_fk_classroom_id_2349e0de_fk_api_class" FOREIGN KEY ("fk_classroom_id") REFERENCES "api_classroom" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "api_measurementstation_fk_classroom_id_2349e0de" ON "api_measurementstation" ("fk_classroom_id");
ALTER TABLE "api_measurement"
    ADD CONSTRAINT "api_measurement_fk_measurement_stati_75ae5add_fk_api_measu" FOREIGN KEY ("fk_measurement_station_id") REFERENCES "api_measurementstation" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "api_measurement_fk_measurement_station_id_75ae5add" ON "api_measurement" ("fk_measurement_station_id");
ALTER TABLE "api_entranceevent"
    ADD CONSTRAINT "api_entranceevent_fk_measurement_stati_e9ab89e3_fk_api_measu" FOREIGN KEY ("fk_measurement_station_id") REFERENCES "api_measurementstation" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "api_entranceevent_fk_measurement_station_id_e9ab89e3" ON "api_entranceevent" ("fk_measurement_station_id");
ALTER TABLE "api_connectionhistory"
    ADD CONSTRAINT "api_connectionhistor_fk_measurement_stati_5301ecee_fk_api_measu" FOREIGN KEY ("fk_measurement_station_id") REFERENCES "api_measurementstation" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "api_connectionhistory_fk_measurement_station_id_5301ecee" ON "api_connectionhistory" ("fk_measurement_station_id");
COMMIT;
