# Data Management and Storage

# Exercise 6 - Create tables in the database

The goal of this exercise is to create tables in the database to accommodate our data. We will start by creating tables corresponding to the NUTS1 to 3, and Municipalities and Freguesias. For that, we will use the SQL DDL command create.

The data to be imported to the database is in csv files, with the following structure (example):

codes|parent_code|Nível|Código|Designação
-----|-----------|-----|------|----------
1|PT|1|1|Continente
2|PT|1|2|Região Autónoma dos Açores
3|PT|1|3|Região Autónoma da Madeira 

This data sample indicates that the table should contain 5 columns. From the sample, it also appear that the first, third and fourth columns have only numeric values. However, if you remember from the data wrangling exercise, there were codes that contained letters. The only column with numeric values only is the column `Nível`. Please, go back to your OpenRefine project and verify that.

Therefore, we need to have this in consideration when defining the schema for the tables. And we can have all tables with the same structure.

To execute this exercise, you can use DBeaver or the MariaDB terminal.

## 1. Select the database

The first thing to do is identify which database you will use. For that, do:
```
USE dms_2022;
```

## 2. Create the first new table

The generic SQL syntax to create a table is 
```
CREATE TABLE table_name (
    column1 datatype,
    column2 datatype,
    column3 datatype,
   ....
); 
```
In our case, for the **NUTS1** table above, the SQL code would be:

```
DROP TABLE IF EXISTS NUTS1;

CREATE TABLE NUTS1 (
    NutsID VARCHAR(9) NOT NULL PRIMARY KEY,
    ParentCodeID VARCHAR(9),
    Level INT(1),
    OriginalCode VARCHAR(9),
    Name VARCHAR(255)
)
ENGINE=InnoDB; 
```

   **Explaination**
   
   In the command, after defining the name of the table, you list the names of the columns, inside a parenthesis. Please notice that we changes the names of the original columns in the table, for consistency. This is perfectly fine. We defined the column `NutsID` as primary key. We also said that the storage engine is INNODB, which is a general-purpose storage engine that balances high reliability and high performance.

You can check the schema of the resulting table, with the SQL command:
```
DESCRIBE NUTS1; 
```

## 3. Create the remaining tables

THe procedure for creating the tables for the other NUTS levels is identical. However, for these NUTS, we will want to reference the `ParentCodeID` columns as foreign keys, in order to establish the relations between each region and its encompassing region. 

Therefore, the SQL command for creating the table **NUTS2** will be:

```
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
```

You can create tables **NUTS3**, **NUTS4** and **NUTS5** modifying the SQL statements above.

## 4. Load data

In this case, we will load data to the database from the csv files we created using OpenRefine. This is possible with the SQL command `LOAD`. You need to specify:
- the name of the file
- the delimiters of the columns
- the delimiters of the lines
- number of rows to ignore

In the case when number and the order of the columns of the csv file is the same of the columns in the table in the database, you do not need to include the list of fields to which data is loaded.

The generic SQL statement is 
```
LOAD DATA [LOCAL] INFILE ´filename' 
INTO TABLE table_name
FIELD TERMINATED BY 'string' ENCLOSED BY 'char'
LINES TERMINATED BY 'string'
IGNORE number LINES;
```
The [complete statement](https://mariadb.com/kb/en/load-data-infile/) includes other optional parameters that might be useful in some cases.


The SQL statement to load data to the **NUST1** table is:

```
LOAD DATA LOCAL INFILE '/home/rfigueira/Documents/projectos/ISA/docencia_aulas/UCs_disciplinas/msc_GAD_2371/Recenseamento_agricola_INE/exercises/NUTS1_2013.csv'
INTO TABLE NUTS1
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
```
The above statement may have changes for your particular environment, namely the path and name of the csv file, and the string that identifies the end of a line.

Check is data was correctly uploaded:
```
SELECT * FROM NUTS1;
```
Most probably, special characters were wrongly interpreted. This is because the default character set of the database differs from the one in the csv file. Let's correct the issue, first by deleting all records from **NUTS1** table:
```
DELETE FROM NUTS1;
```
Then, repeat the load of data, but adding a parameter to inform the character set of the file:
```
LOAD DATA LOCAL INFILE '/home/rfigueira/Documents/projectos/ISA/docencia_aulas/UCs_disciplinas/msc_GAD_2371/Recenseamento_agricola_INE/exercises/NUTS1_2013.csv'
INTO TABLE NUTS1
CHARACTER SET UTF8
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
```
Check is data was correctly uploaded.

Repeat the operation to load data for tables **NUTS2**, **NUTS3**, **NUTS4** and **NUTS5**
