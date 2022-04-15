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
//  


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





