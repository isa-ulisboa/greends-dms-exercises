# Data Management and Storage

# Exercise 11 - Normalization of the dms_INE database

The goal of this exercise is to perform the normalization of the database `dms_INE`
according to the **3NF**. We will go through each of the tables to identify what 
violated the 3NF, and make necessary changes, including the creation of new
tables. 

Additionally, we will implement **CONSTRAINTS** to the tables (addition of **PRIMARY** and
**FOREIGN KEYS**), which will improve the security and quality of the data.

## Preparation of the exercise

This exercise can be run at the MySQL command line or in DBeaver.

It makes structural changes in all tables of the database. The starting
version of the database is as in dms_INE_v1. If for some reason you need to restart,
you can revert to the beginning state importing this version, using in the terminal 
of the operating system the following command:

```
$ mysql -u root -p dms_INE < dms_INE_v1.sql
``` 
This needs to be run from the place you have unzipped `dms_INE_v1.sql.zip`, which 
can be downloaded from the `data` folder of this github repository.

## 1. Analyze tables

The first step is to verify the current structure of the tables, and identify
which are the violations of the criteria of 3 NF.

In principle, all table are already in 1NF, meaning they are atomic (no cell of the 
table has more than one value). You can verify this by making simple SELECT queries
to the tables.

Let's make sure we have the correct table active:
```
mysql > USE dms_INE;
```
And see which tables are in the database;
```
mysql > SHOW TABLES;
```
The list should be as the following
 * education
 * grassland
 * labour
 * livestock
 * permanent_crop
 * production
 * region
 * temporary_crop

 These correspond to the entities we identified and selected from the INE's 
 Agricultural census report. The basic unit of the tables is the `region`, so it
 makes sense to analyze this table first, as the other tables are going to link 
 to this one, through the field `NutsID`

## 2. Make changes in the **region** table

Analyze the region table:

```
SELECT * FROM region r ;
```
If we want to check the schema of the table, we can run:
```
DESCRIBE region;
```
Looking at the values of the table, we can verify the need of the following changes:
 * remove originalCode
 * move region_level to a new table because it is partial dependent of Level
 * add a foreign key to region_level
 * make NutsID a primary key
 
 The following SQL code will make these changes. Read it carefully and make sure
 you understand what is done by each command. It is recommended, at least for this
 first case, to run each query step by step, to make sure you understand the need
 of the statement and what it does.

```
-- remove colum
ALTER TABLE region DROP COLUMN OriginalCode;

-- create table region_level
DROP TABLE IF EXISTS region_level;

CREATE TABLE region_level (level_ID INT PRIMARY KEY)
SELECT DISTINCT `Level` as level_ID, region_level FROM region r ;

-- check result of the new table created
SELECT * FROM region_level;
DESCRIBE region_level;

-- there is a typo in the values of region_level, with NUST that should be NUTS
UPDATE region_level SET region_level = REPLACE(region_level, 'NUST', 'NUTS') 
WHERE region_level LIKE 'NUST%';

-- alter table region to rename column and drop another column
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
```
After running all queries above, make a general SELECT on the two tables region and 
region_level.

After this change, if we want to obtain the name of the region level associated 
with the name of the region, we will need to establish and **implicit join** of an
**inner join** between the tables:

```
select * from region r, region_level rl WHERE r.level_ID = rl.level_ID ;

```
or

```
SELECT * FROM region r INNER JOIN region_level rl ON r.level_ID = rl.level_ID ;
```

## 3. Make changes to the **production** table

Again, we can start by checking the current status of the table:

```
-- check table production;
SELECT * FROM production p ;
```

Q.1. Can you identify the changes needed?
`````
-- Provide your answer here...
`````
If you identified the following, these are teh needed changes
 * needs a primary key
 * needs a foreign key on NutsID
 * region_name does not depend on the new primary key, but on NutsID, it can be removed

The following code will make the changes
```
ALTER TABLE production
ADD COLUMN `production_ID` INT NOT NULL AUTO_INCREMENT,
DROP COLUMN region_name,
ADD PRIMARY KEY (production_ID),
ADD FOREIGN KEY (NutsID) REFERENCES region(NutsID);
```

## 4. Make changes to the **education** table

Unlike production, we need to create a new table with education level, to make 
the table education compatible with 3NF:
```
-- check table education;
SELECT * FROM education e ;
```
Q.2. Again, identify the changes needed?
`````
-- Provide your answer here...
`````
In this case, these are the changes:

 * create table education_level
 * add column education_level_ID
 * needs a primary key
 * needs a foreign key on NutsID
 * region_name does not depend on the new primary key, but on NutsID 

 The following code will make it:

```
-- remove a table if exists
DROP TABLE IF EXISTS education_level;

-- create the table to contain education level categories
CREATE TABLE education_level (education_level_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT)
SELECT DISTINCT education_level FROM education e ;

-- check it was created
SELECT * FROM education_level;

-- make the changes in table education, all in the same statement
ALTER TABLE education
ADD COLUMN `education_ID` INT NOT NULL AUTO_INCREMENT,
ADD COLUMN education_level_ID INT,
ADD PRIMARY KEY (education_ID),
ADD FOREIGN KEY (NutsID) REFERENCES region(NutsID);

-- we need to update table education, adding values to column education_level_ID
UPDATE education e, education_level el SET e.education_level_ID = el.education_level_ID 
WHERE e.education_level = el.education_level;

-- delete column education_level from education 
ALTER TABLE education 
DROP COLUMN education_level;

-- add foreign key on education_level_ID
ALTER TABLE education 
ADD FOREIGN KEY (education_level_ID) REFERENCES education_level(education_level_ID);
```

## 5. Make changes to the **permanent_crop** table

The permanent_crop requires several changes, as can be identifying by observing
its records:
```
-- check table permanent_crop;
SELECT * FROM permanent_crop ;
```
The list of modifications includes:
 * add column permanent_crop_ID to be primary key
 * needs a foreign key on NutsID
 * remove region_name and region_level
 * move crop_name to a new table and link

The following code, similar to the one above, will make the changes needed

```
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
```

## 5. Make changes to the **temporary_crop** table

The **temporary_crop** table is similar to the **permanent_crop**. 

```
-- check table temporary_crop;
SELECT * FROM temporary_crop ;
```
Q.3. Can you make the changes? First, identify them here:
`````
/* What is need to do:
 * delete region_name, region_level, crop_name 
 * create a new table crop_name
 * add primary key
 * add foreign key: region(NustID) and crop_name(crop_name_ID)
 */
`````
Q.4. And adapt the code from above here:
`````
-- create new table 
 
drop table if exists temporary_crop_name;

create table temporary_crop_name (tc_name_ID int not null primary key auto_increment)
select distinct crop_name from temporary_crop tc ;

-- edit temporary_crop

alter table temporary_crop 
drop column region_name,
drop column region_level,
add column tc_name_ID int,
add column tc_ID int not null auto_increment,
add primary key (tc_ID),
add foreign key (NutsID) references region(NutsID), 
add foreign key (tc_name_ID) references temporary_crop_name(tc_name_ID);

-- add values to tc_name_ID

update temporary_crop tc, temporary_crop_name tcn set tc.tc_name_ID = tcn.tc_name_ID 
where tc.crop_name = tcn.crop_name ;

`````

## 6. Make changes in the remaining tables

The tables 

- grassland
- labour
- livestock

also need to be processed to be normalized. The changes needed are repetitions of 
the cases above. Create your SQL code by adapting the used code, in accordance
with the changes required by each table:

`````
-- TABLE GRASSLAND -- 

select * from grassland g ;
describe grassland;

/* What is need to do:
 * add a primary key 
 * add foreign key NutsID
 * delete region_name and region_level columns */

alter table grassland 
add column `grassland_ID` int not null auto_increment,
add primary key (grassland_ID),
add foreign key (NutsID) references region(NutsID),
drop column region_name,
drop column region_level;

-- TABLE LABOUR --

select * from labour;
describe labour ;

/* What is need to do:
 * add a primary key
 * add foreign key NutsID
 * create a new table type_labour_name and link with type_labour_ID*/

-- create table type_labour_name 

drop table if exists type_labour_name;

create table type_labour_name (type_labour_ID int not null primary key auto_increment)
select distinct type_labour from labour l ;

-- add add a primary key, add foreign key NutsID, add column type_labour_ID

alter table labour 
add column type_labour_ID int,
add column `labour_ID` int not null auto_increment,
add primary key (labour_ID),
add foreign key (NutsID) references region(NutsID);

-- add values to the column type_labour_ID

update labour l, type_labour_name tln set l.type_labour_ID = tln.type_labour_ID
where l.type_labour = tln.type_labour;

-- link with type_labour_ID and delete type_labour column

alter table labour 
add foreign key (type_labour_ID) references type_labour_name(type_labour_ID),
drop column type_labour;

select * from labour;

-- TABLE livestock --

select * from livestock l ;
describe livestock ;

/*What is necessary to do:
 * add a primary key to livestock
 * add a foreign key region(NutsID) to livestock
 * creat a new table livestock_name and link it with livestock (livestock_name_ID)
 * delete animal_species from livestock
 */

-- create a new table livestock_name

drop table if exists livestock_name;

create table livestock_name (livestock_name_ID int not null primary key auto_increment)
select distinct animal_species from livestock l ;

-- add a primary key, a foreign key region(NutsID), and the column livestock_name_ID to livestock

alter table livestock 
add column livestock_name_ID int,
add column `livestock_ID` int not null auto_increment,
add primary key (livestock_ID),
add foreign key (NutsID) references region(NutsID);

-- add values to the column livestock_name_ID

update livestock l, livestock_name lsn set l.livestock_name_ID = lsn.livestock_name_ID 
where l.animal_species = lsn.animal_species ;

-- delete animal_species from livestock and create a foreign key (livestock_name_ID)

alter table livestock 
add foreign key (livestock_name_ID) references livestock_name(livestock_name_ID),
drop column animal_species;

select * from livestock l ;

`````

## 7. Complete SQL script
If you completed the code and executed it without issues, great! If not, you  can 
check and run the full SQL script `dms_ex_11_normalization.sql`, which is available 
from the `scripts` directory of the repository. It can be run 
using DBeaver, or in the operating system command line, with the command:
```
$ mysql -u dms_user -p dms_INE < dms_INE_normalization.sql
```  

## 8. Dump of the database normalized file

We have made a new version of the database, which is now fully normalized. The dump
of the database after making all changes if available in the file `dms_INE_v2.sql.zip`
that is in the data directory.
