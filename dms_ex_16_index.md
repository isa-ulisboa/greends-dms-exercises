# Data Management and Storage

# Exercise 16 - SQL Indexes

The goal of this exercise is to demonstrate why we need to carefully organise
data on a database, and the benefit of indexes.

## Introduction

Database normalization has the main purpose to provide consistency in your data. 
But another benefit is that the performance of your database will increase, due 
to the creation of indexes. Fields that are defined as primary key and foreign 
keys are indexed.

An index in a look up table for finding records quick. It should be used in fields 
used frequently for searching. There are several types of indexes, about which,
for MariaDB, you can learn more [here](https://mariadb.com/kb/en/the-essentials-of-an-index/).

In this exercise, we will demonstrate the use of indexes, and how this increases
the speed of data searching.

## Preparation of the exercise

This exercise should be done in DBeaver, so that you can observe in the status bar 
the time of execution of the queries. We will use the 
database dms_INE version 2 that resulted from [Exercise 13](https://github.com/isa-ulisboa/greends-dms-exercises/blob/main/dms_ex_13_normalization.md). You can obtain the 
dump of that from the file dms_INE_v2.sql.zip, which can be downloaded from the 
data folder of this github repository.

## 1. Run queries in tables with indexes

The first step is to prepare a complicated query that joins several tables. The 
goal of the query is to calculate the average area for permanent and temporary
crops, for a certain region level and per year.

First, make sure that you are using the correct database with the SQL command `USE`:

```SQl
USE dms_INE;
```

Next, define the query:

```SQL
-- create a complex query
SELECT pc.year, r.NutsID , region_name , pcn.crop_name as perm_crop, avg(pc.area) as area_perm, tcn.crop_name as temp_crop, avg(tc.area) as area_temp 
FROM region r  
	INNER JOIN region_level rl on r.level_ID = rl.level_ID 
	INNER JOIN permanent_crop pc on r.NutsID = pc.NutsID 
	INNER JOIN permanent_crop_name pcn on pc.pc_name_ID = pcn.pc_name_ID 
	INNER JOIN temporary_crop tc on r.NutsID = tc.NutsID 
	INNER JOIN temporary_crop_name tcn on tc.tc_name_ID = tcn.tc_name_ID 
WHERE rl.region_level LIKE 'NUTS1' 
	AND pcn.crop_name NOT LIKE 'T%' 
	AND tcn.crop_name NOT LIKE 'T%' 
	AND pc.year = tc.`year` 
GROUP BY pc.year, pcn.crop_name, tcn.crop_name ;
```

Read carefully the query to make sure you understand what it is doing. Then, 
execute it and take note of the time of execution.

## 2. Create new tables without indexes

The next step is create copies of the tables used in the previous query. A simple 
`CREATE TABLE` combined with `SELECT` will do the task. For each new table, put a 
prefix `t1_` before the name of the original table.

```SQL
-- make a simple copy of table region
CREATE TABLE t1_region SELECT * FROM region r;

-- describe to see its schema
DESCRIBE t1_region;

-- make a simple copy of table region_level
CREATE TABLE t1_region_level SELECT * FROM region_level r; 

-- describe to see its schema
DESCRIBE t1_region_level;

-- make a simple copy of table permanent_crop
CREATE TABLE t1_permanent_crop SELECT * FROM permanent_crop pc;

-- describe to see its schema
DESCRIBE t1_permanent_crop;

-- make a simple copy of table permanent_crop
CREATE TABLE t1_permanent_crop_name SELECT * FROM permanent_crop_name pcn;

-- describe to see its schema
DESCRIBE t1_permanent_crop_name;

-- make a simple copy of table permanent_crop
CREATE TABLE t1_temporary_crop SELECT * FROM temporary_crop pc;

-- describe to see its schema
DESCRIBE t1_temporary_crop;

-- make a simple copy of table permanent_crop
CREATE TABLE t1_temporary_crop_name SELECT * FROM temporary_crop_name pcn;

-- describe to see its schema
DESCRIBE t1_temporary_crop_name;
```

We also do a DESCRIBE statement to check that the schema of the table does not 
contain any indexes.


## 3. Do a query on tables not indexed

We will now repeat the query, but on the new tables created that do not contain 
indexes. Write the transformed query to execute:
```SQL
SELECT ...
```
Take note of the execution time. It should be much slower that the previous 
query on indexed tables.


## 4. Add indexes

We can now test the effect of adding indexes to the tables. We will add indexes 
to the columns that serve as joins between tables `region` and tables `permanent_crop` 
and `temporary_crop`.

This is a DDL command that changes the schema of the tables. The general syntax is:

```SQL
ALTER TABLE <table_name> ADD INDEX <name_of_index> (<column_name>);
```

In our case, it will be:

```SQL
-- create an index
ALTER TABLE t1_permanent_crop ADD INDEX pc_nutsid (NutsID);
ALTER TABLE t1_temporary_crop ADD INDEX tc_nutsid (NutsID);
```

Execute each of the commands, and then rerun the complex query, and take note of 
the execution time. Did you notice a difference?

We can also check that the change in the execution time. If you delete the indexes,
the execution time will increase again. The general syntax for deleting indexes
is:

```SQL
ALTER TABLE <table_name> DROP INDEX <name_of_index>;
```
Note that you do not need to indicate the name of the column. In our case, it 
will be:

```SQL
-- create an index
ALTER TABLE t1_permanent_crop DROP INDEX pc_nutsid;
ALTER TABLE t1_temporary_crop DROP INDEX tc_nutsid;
```
After deleting the indexes, rerun the complex query. What do you see?


