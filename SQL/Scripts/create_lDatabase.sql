-- Check if database already exists if yes drop it and recreate
DROP SCHEMA IF EXISTS `ddi_le2_sql` ;

-- Create Databases
-- Create ddi_le2_sql database
CREATE SCHEMA IF NOT EXISTS `ddi_le2_sql` ;
SHOW WARNINGS;
USE `ddi_le2_sql` ;

-- Create Tables
-- Create Table classroom
SHOW WARNINGS;
CREATE TABLE `ddi_le2_sql`.`api_classroom` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NULL,
  `description` VARCHAR(200) NULL,
  `room_number` VARCHAR(100) NULL,
  `updated_on` DATETIME NULL,
  PRIMARY KEY (`id`));

  
-- Create Table Measurementstation
SHOW WARNINGS;
CREATE TABLE `ddi_le2_sql`.`api_measurementstation` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `fk_classroom_id` INT NULL,
  `active` TINYINT NULL,
  `ip_address` BIGINT NULL,
  `name` VARCHAR(50) NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_classroom_id`
    FOREIGN KEY (`fk_classroom_id`)
    REFERENCES `ddi_le2_sql`.`api_classroom` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
COMMENT = 'ip_address is saved as an binary integer';

-- Create Table Measurements
SHOW WARNINGS;
  CREATE TABLE `ddi_le2_sql`.`api_measurement` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `time` DATETIME NULL,
  `co2` DECIMAL(19,10) NULL,
  `fk_measurement_station_id` INT NULL,
  `temperature` DECIMAL(19,10) NULL,
  `humidity` DECIMAL(19,10) NULL,
  `insert_time` DATETIME NULL,
  `light` DECIMAL(19,10) NULL,
  `motion` TINYINT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_measurement_station_id_idx` (`fk_measurement_station_id` ASC) VISIBLE,
  CONSTRAINT `fk_measurement_station_id`
    FOREIGN KEY (`fk_measurement_station_id`)
    REFERENCES `ddi_le2_sql`.`api_measurementstation` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
COMMENT = 'if a measurementstation is altered, cascade the changes ';

-- Create Table EntranceEvents
SHOW WARNINGS;
CREATE TABLE `ddi_le2_sql`.`api_entranceevent` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `fk_measurement_station_id` INT NULL,
  `time` DATETIME NULL,
  `change` INT NULL,
  `insert_time` DATETIME NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_measurement_station_id_idx` (`fk_measurement_station_id` ASC) VISIBLE,
  CONSTRAINT `fk_measurement_station_id2`
    FOREIGN KEY (`fk_measurement_station_id`)
    REFERENCES `ddi_le2_sql`.`api_measurementstation` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

-- Create Procedures for Data Inserts

drop procedure if exists `ddi_le2_sql`.Insert_api_measurement;
DELIMITER //  
CREATE PROCEDURE `ddi_le2_sql`.Insert_api_measurement(IN executioncount INT)   
BEGIN
DECLARE i INT DEFAULT 1; 
WHILE (i <= executioncount) DO
    INSERT INTO `ddi_le2_sql`.`api_measurement`
(`id`,
`time`,
`co2`,
`fk_measurement_station_id`,
`temperature`,
`humidity`,
`insert_time`,
`light`,
`motion`)
VALUES
(0,
NOW(),
(select  round(rand() *(1500-500) + 500,10)),
(select round( rand() *(10-1) + 1)),
(select  round(rand() *(23-17) + 17,10)),
(select  round(rand() *(60-40) + 40,10)),
NOW(),
(select  round(rand() *(1500-400) + 400,10)),
(select round( rand() *(1-0) + 0)));
    SET i = i+1;
END WHILE;
END;

drop procedure if exists `ddi_le2_sql`.Insert_api_measurementstation;
CREATE PROCEDURE `ddi_le2_sql`.Insert_api_measurementstation(IN executioncount INT)   
BEGIN
DECLARE i INT DEFAULT 1; 
WHILE (i <= executioncount) DO
    INSERT INTO `ddi_le2_sql`.`api_measurementstation`
(`id`,
`fk_classroom_id`,
`active`,
`ip_address`,
`name`)
VALUES
(0,
(select round( rand() *(8-1) + 1)),
(select round( rand() *(1-0) + 0)),
(select inet_aton((SELECT CONCAT("192.168.",(select round(rand()*(254-1)+1)),".",(select round(rand()*(254-1)+1)))))),
(SELECT CONCAT("Messtation ",(select round( rand() *(200-0) + 0)))));
    SET i = i+1;
END WHILE;
END;

drop procedure if exists `ddi_le2_sql`.Insert_api_entranceevent;
CREATE PROCEDURE `ddi_le2_sql`.Insert_api_entranceevent(IN executioncount INT)   
BEGIN
DECLARE i INT DEFAULT 1; 
WHILE (i <= executioncount) DO
INSERT INTO `ddi_le2_sql`.`api_entranceevent`
(`id`,
`fk_measurement_station_id`,
`time`,
`change`,
`insert_time`)
VALUES
(0,
(select round( rand() *(10-1) + 1)),
NOW(),
(select round( rand() *(3-(-3)) + -3)),
NOW());
    SET i = i+1;
END WHILE;
END;
//  

-- Data Inserts 
-- Classroom Inserts
START TRANSACTION;
INSERT INTO `ddi_le2_sql`.`api_classroom`
(`id`,
`name`,
`description`,
`room_number`,
`updated_on`)
VALUES
(0,
"1.010",
    "Lichthof",
    "1.010",
NOW());

INSERT INTO `ddi_le2_sql`.`api_classroom`
(`id`,
`name`,
`description`,
`room_number`,
`updated_on`)
VALUES
(0,
"1.013",
    "Standardbestuhlung: Seminar Front
    Projektion: zentral einzeln
    Audiokanäle: nein
    Laptop: nein",
    "1.013",
NOW());

INSERT INTO `ddi_le2_sql`.`api_classroom`
(`id`,
`name`,
`description`,
`room_number`,
`updated_on`)
VALUES
(0,
"1.021",
    "Standardbestuhlung: Seminar Front
    Projektion: zentral einzeln
    Audiokanäle: nein
    Laptop: nein",
    "1.021",
NOW());

INSERT INTO `ddi_le2_sql`.`api_classroom`
(`id`,
`name`,
`description`,
`room_number`,
`updated_on`)
VALUES
(0,
"5.1B51",
    "Standartbestuhlung: Seminar U-Form
    Projektion: seitlich einzeln
    Audiokanäle: nein
    Laptop: nein
    Wandtafel: geteilt",
    "5.1B51",
NOW());

INSERT INTO `ddi_le2_sql`.`api_classroom`
(`id`,
`name`,
`description`,
`room_number`,
`updated_on`)
VALUES
(0,
"5.1D11",
    "Standardbestuhlung: Seminar Front
    Projektion: zentral einzeln
    Audiokanäle: nein
    Laptop: nein",
    "5.1D11",
NOW());

INSERT INTO `ddi_le2_sql`.`api_classroom`
(`id`,
`name`,
`description`,
`room_number`,
`updated_on`)
VALUES
(0,
"5.3B51",
    "DS Semester 1 & 2",
    "5.3B51",
NOW());

INSERT INTO `ddi_le2_sql`.`api_classroom`
(`id`,
`name`,
`description`,
`room_number`,
`updated_on`)
VALUES
(0,
"5.3B53",
    "DS Semester 3 & 4",
    "5.3B53",
NOW());

INSERT INTO `ddi_le2_sql`.`api_classroom`
(`id`,
`name`,
`description`,
`room_number`,
`updated_on`)
VALUES
(0,
"5.3C59",
    "DS Semester 5 & 6",
    "5.3C59",
NOW());

COMMIT;


-- Other Inserts with Stored Procedures
START TRANSACTION;
CALL Insert_api_measurementstation(200);
CALL Insert_api_measurement(100000);
CALL Insert_api_entranceevent(100000);
COMMIT;