-- use dms_INE
use dms_INE;

/**
 * The following makes structural changes in th database
 * It is important to make a database backup, in case it is necessary to revert changes
 * In the OS commadn line, run:
 * mysqldump -u root -p dms_INE > dms_INE_2022-11-30.sql
 */

-- list tables
SHOW tables;

/* list of tables
 * education*
 * grassland*
 * labour*
 * livestock*
 * perm_crop_freg
 * permanent_crop*
 * production*
 * region*
 * tempcrop
 * temporary_crop*
 */


-- analyse region 
SELECT * FROM region r ;
DESCRIBE region;

/* changes to make to table region
 * remove originalCode
 * move region_level to a new table because it is partial dependent of Level
 * add a foreign key to region_level
 * make NutsID a primary key
 */

-- remove colum
ALTER TABLE region DROP COLUMN OriginalCode;

-- create table region_level
DROP TABLE IF EXISTS region_level;

CREATE TABLE region_level (level_ID INT PRIMARY KEY)
SELECT DISTINCT `Level` as level_ID, region_level FROM region r ;

-- check result
SELECT * FROM region_level;
DESCRIBE region_level;

-- there is a typo in the values of region_level, with NUST that should be NUTS
UPDATE region_level SET region_level = REPLACE(region_level, 'NUST', 'NUTS') 
WHERE region_level LIKE 'NUST%';

-- alter table region
ALTER TABLE region 
RENAME COLUMN `Level` TO `level_ID`;

ALTER TABLE region 
DROP COLUMN region_level;

-- define foreign key
ALTER TABLE region 
ADD FOREIGN KEY (level_ID) REFERENCES region_level(level_ID);

-- verify that NutsID is unique
SELECT NutsID FROM region r GROUP BY NutsID HAVING count(*) > 1;

-- define NutsID as primary key
ALTER TABLE region 
ADD PRIMARY KEY (NutsID);

-- check table production;
SELECT * FROM production p ;
DESCRIBE production ;

/* needs a primary key
 * needs a foreign key on NutsID
 * region_name does not depend on the new primary key, but on NutsID 
 * it can be removed
 */

ALTER TABLE production
ADD COLUMN `production_ID` INT NOT NULL AUTO_INCREMENT,
DROP COLUMN region_name,
ADD PRIMARY KEY (production_ID),
ADD FOREIGN KEY (NutsID) REFERENCES region(NutsID);

-- check table education;
SELECT * FROM education ;
DESCRIBE education ;

/* create table education_level
 * add column education_level_ID
 * needs a primary key
 * needs a foreign key on NutsID
 * region_name does not depend on the new primary key, but on NutsID 
 */
DROP TABLE IF EXISTS education_level;

CREATE TABLE education_level (education_level_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT)
SELECT DISTINCT education_level FROM education e ;

SELECT * FROM education_level;

ALTER TABLE education
ADD COLUMN `education_ID` INT NOT NULL AUTO_INCREMENT,
ADD COLUMN education_level_ID INT,
ADD PRIMARY KEY (education_ID),
ADD FOREIGN KEY (NutsID) REFERENCES region(NutsID);

-- add values to column education_level_ID
UPDATE education e, education_level el SET e.education_level_ID = el.education_level_ID 
WHERE e.education_level = el.education_level;

-- delete column education_level from education 
ALTER TABLE education 
DROP COLUMN education_level;

-- add foreign key on education_level_ID
ALTER TABLE education 
ADD FOREIGN KEY (education_level_ID) REFERENCES education_level(education_level_ID);


 -- check table grassland;
SELECT * FROM grassland ;
DESCRIBE grassland ;

/* 
 * add column grassland_ID
 * needs a primary key
 * needs a foreign key on NutsID
 * remove region_name and region_level
 */

ALTER TABLE grassland
ADD COLUMN `grassland_ID` INT NOT NULL AUTO_INCREMENT,
ADD PRIMARY KEY (grassland_ID),
ADD FOREIGN KEY (NutsID) REFERENCES region(NutsID),
DROP COLUMN region_name,
DROP COLUMN region_level;

-- check table labour;
SELECT * FROM labour ;
DESCRIBE labour ;

/* create table type_labour
 * add column type_labour_ID
 * needs a primary key
 * needs a foreign key on NutsID 
 */

DROP TABLE IF EXISTS type_labour;

CREATE TABLE type_labour (type_labour_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT)
SELECT DISTINCT type_labour FROM labour ;

SELECT * FROM type_labour;

ALTER TABLE labour
ADD COLUMN `labour_ID` INT NOT NULL AUTO_INCREMENT,
ADD COLUMN type_labour_ID INT,
ADD PRIMARY KEY (labour_ID),
ADD FOREIGN KEY (NutsID) REFERENCES region(NutsID);

-- add values to column type_labour_ID in labour table
UPDATE labour l, type_labour tl SET l.type_labour_ID = tl.type_labour_ID 
WHERE l.type_labour = tl.type_labour;

-- delete column type_labour from labour 
ALTER TABLE labour 
DROP COLUMN type_labour,
ADD FOREIGN KEY (type_labour_ID) REFERENCES type_labour(type_labour_ID);


 -- check table livestock;
SELECT * FROM livestock ;
DESCRIBE livestock ;

/* create table livestock_name
 * add column livestock_name_ID
 * needs a primary key
 * needs a foreign key on NutsID
 */

DROP TABLE IF EXISTS livestock_name;

CREATE TABLE livestock_name (livestock_name_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT)
SELECT DISTINCT animal_species FROM livestock ;

SELECT * FROM livestock_name;

ALTER TABLE livestock
ADD COLUMN `livestock_ID` INT NOT NULL AUTO_INCREMENT,
ADD COLUMN livestock_name_ID INT,
ADD PRIMARY KEY (livestock_ID),
ADD FOREIGN KEY (NutsID) REFERENCES region(NutsID);

-- add values to column livestock_name_ID in livestock table
UPDATE livestock l, livestock_name tl SET l.livestock_name_ID = tl.livestock_name_ID 
WHERE l.animal_species = tl.animal_species;

-- delete column animal_species from livestock 
ALTER TABLE livestock 
DROP COLUMN animal_species,
ADD FOREIGN KEY (livestock_name_ID) REFERENCES livestock_name(livestock_name_ID);


 -- check table permanent_crop;
SELECT * FROM permanent_crop ;
DESCRIBE permanent_crop ;

/* 
 * add column permanent_crop_ID to be primary key
 * needs a foreign key on NutsID
 * remove region_name and region_level
 * move crop_name to a new table and link
 */

DROP TABLE IF EXISTS permanent_crop_name;

CREATE TABLE permanent_crop_name (pc_name_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT)
SELECT DISTINCT crop_name FROM permanent_crop ;

SELECT * FROM permanent_crop_name;

ALTER TABLE permanent_crop
ADD COLUMN `permanent_crop_ID` INT NOT NULL AUTO_INCREMENT,
ADD COLUMN pc_name_ID INT,
ADD PRIMARY KEY (permanent_crop_ID),
ADD FOREIGN KEY (NutsID) REFERENCES region(NutsID);

-- add values to column permanent_crop_ID in permanent_crop table
UPDATE permanent_crop l, permanent_crop_name tl SET l.pc_name_ID = tl.pc_name_ID 
WHERE l.crop_name = tl.crop_name;

-- delete column crop_name from permanent_crop 
ALTER TABLE permanent_crop 
DROP COLUMN crop_name,
ADD FOREIGN KEY (pc_name_ID) REFERENCES permanent_crop_name(pc_name_ID);

ALTER TABLE permanent_crop 
DROP COLUMN region_name,
DROP COLUMN region_level;

 -- check table temporary_crop;
SELECT * FROM temporary_crop ;
DESCRIBE temporary_crop ;

/* 
 * add column temporary_crop_ID to be primary key
 * needs a foreign key on NutsID
 * remove region_name and region_level
 * move crop_name to a new table and link
 */

DROP TABLE IF EXISTS temporary_crop_name;

CREATE TABLE temporary_crop_name (tc_name_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT)
SELECT DISTINCT crop_name FROM temporary_crop ;

SELECT * FROM temporary_crop_name;

ALTER TABLE temporary_crop
ADD COLUMN `temporary_crop_ID` INT NOT NULL AUTO_INCREMENT,
ADD COLUMN tc_name_ID INT,
DROP COLUMN region_name,
DROP COLUMN region_level,
ADD PRIMARY KEY (temporary_crop_ID),
ADD FOREIGN KEY (NutsID) REFERENCES region(NutsID);

-- add values to column temporary_crop_ID in temporary_crop table
UPDATE temporary_crop l, temporary_crop_name tl SET l.tc_name_ID = tl.tc_name_ID 
WHERE l.crop_name = tl.crop_name;

-- delete column crop_name from temporary_crop 
ALTER TABLE temporary_crop 
DROP COLUMN crop_name,
ADD FOREIGN KEY (tc_name_ID) REFERENCES temporary_crop_name(tc_name_ID);
