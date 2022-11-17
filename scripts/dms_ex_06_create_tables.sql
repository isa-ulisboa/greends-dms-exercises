-- Master Green Data Science
-- Course Data Management and Storage 2022/2023
--
-- Create table for NUTS1
-- Delete if the table exists
-- It will fail because of existing dependencies
DROP TABLE IF EXISTS NUTS1;

CREATE TABLE NUTS1 (
    NutsID VARCHAR(9) NOT NULL PRIMARY KEY,
    ParentCodeID VARCHAR(9),
    Level INT(1),
    OriginalCode VARCHAR(9),
    Name VARCHAR(255)
)
ENGINE=InnoDB;

DESCRIBE NUTS1;

-- Create table for NUTS2
DROP TABLE IF EXISTS NUTS2;

CREATE TABLE NUTS2 (
    NutsID VARCHAR(9) NOT NULL PRIMARY KEY,
    ParentCodeID VARCHAR(9),
    Level INT(1),
    OriginalCode VARCHAR(9),
    Name VARCHAR(255),
    FOREIGN KEY (ParentCodeID) REFERENCES NUTS1(NutsID)
)
ENGINE=InnoDB; 

DESCRIBE NUTS2;

-- Create table for NUTS3
DROP TABLE IF EXISTS NUTS3;

CREATE TABLE NUTS3 (
    NutsID VARCHAR(9) NOT NULL PRIMARY KEY,
    ParentCodeID VARCHAR(9),
    Level INT(1),
    OriginalCode VARCHAR(9),
    Name VARCHAR(255),
    FOREIGN KEY (ParentCodeID) REFERENCES NUTS2(NutsID)
)
ENGINE=InnoDB; 

DESCRIBE NUTS3;

-- Create table for NUTS4
DROP TABLE IF EXISTS NUTS4;

CREATE TABLE NUTS4 (
    NutsID VARCHAR(9) NOT NULL PRIMARY KEY,
    ParentCodeID VARCHAR(9),
    Level INT(1),
    OriginalCode VARCHAR(9),
    Name VARCHAR(255),
    FOREIGN KEY (ParentCodeID) REFERENCES NUTS3(NutsID)
)
ENGINE=InnoDB; 

DESCRIBE NUTS4;

-- Create table for NUTS5
DROP TABLE IF EXISTS NUTS5;

CREATE TABLE NUTS5 (
    NutsID VARCHAR(9) NOT NULL PRIMARY KEY,
    ParentCodeID VARCHAR(9),
    Level INT(1),
    OriginalCode VARCHAR(9),
    Name VARCHAR(255),
    FOREIGN KEY (ParentCodeID) REFERENCES NUTS4(NutsID)
)
ENGINE=InnoDB; 

DESCRIBE NUTS5;


-- load data for table NUTS1
-- if this command does not work, execute it directly in a mysql session on the terminal
LOAD DATA LOCAL INFILE '/home/rfigueira/Documents/projectos/ISA/docencia_aulas/UCs_disciplinas/msc_GAD_2371/Recenseamento_agricola_INE/INE_base_de_dados/data_processing/NUTS1_2013.csv'
INTO TABLE NUTS1
CHARACTER SET UTF8
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- load data for table NUTS2
LOAD DATA LOCAL INFILE '/home/rfigueira/Documents/projectos/ISA/docencia_aulas/UCs_disciplinas/msc_GAD_2371/Recenseamento_agricola_INE/INE_base_de_dados/data_processing/NUTS2_2013.csv'
INTO TABLE NUTS2
CHARACTER SET UTF8
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- load data for table NUTS3
LOAD DATA LOCAL INFILE '/home/rfigueira/Documents/projectos/ISA/docencia_aulas/UCs_disciplinas/msc_GAD_2371/Recenseamento_agricola_INE/INE_base_de_dados/data_processing/NUTS3_2013.csv'
INTO TABLE NUTS3
CHARACTER SET UTF8
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- load data for table NUTS4
LOAD DATA LOCAL INFILE '/home/rfigueira/Documents/projectos/ISA/docencia_aulas/UCs_disciplinas/msc_GAD_2371/Recenseamento_agricola_INE/INE_base_de_dados/data_processing/NUTS4_2013.csv'
INTO TABLE NUTS4
CHARACTER SET UTF8
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- load data for table NUTS5
LOAD DATA LOCAL INFILE '/home/rfigueira/Documents/projectos/ISA/docencia_aulas/UCs_disciplinas/msc_GAD_2371/Recenseamento_agricola_INE/INE_base_de_dados/data_processing/NUTS5_2013.csv'
INTO TABLE NUTS5
CHARACTER SET UTF8
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
