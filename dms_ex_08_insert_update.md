# Data Management and Storage

# Exercise 8 - INSERT, UPDATE and DELETE (DML statements)

The goal of this exercise is to exercise SQL statements with **INSERT**, **UPDATE**
and **DELETE** statements.

## Preparation of the exercise

1. Open DBeaver and open a connection to your local MariaDB installation, with the 
user `dms_user`.

2. Ensure that you are using the `dms_INE` database. Execute the statement
```
USE dms_INE;
```
3. Try to write the statements yourself in DBeaver, and not simply copy from the exercise sheet. This will improve your skills in writing SQL and using DBeaver 
autocomplete function.


## 1. INSERT records

We will do these changes in a copy of the `region` table. First, copy the table:

```
CREATE TABLE region_temp
    SELECT * FROM region;
```
Now, let's perform the changes with INSERT. 

1. First, add a new row for the level country

```
INSERT INTO region_temp 
    (NutsID, `Level`, OriginalCode, region_name,region_level)
  VALUES 
    ('PT', 0, 'PT', 'Portugal', 'country');
```

  Confirm that the new records was added with a SELECT statement:

```
SELECT * FROM region_temp WHERE region_name = 'Portugal'; 
```

2. Now, let's add two new records at once:

```
INSERT INTO region_temp 
    (NutsID, `Level`, OriginalCode, region_name,region_level)
  VALUES 
    ('ES', 0, 'ES', 'Espanha', 'country'),
    ('FR', 0, 'FR', 'França', 'country');
```
Let's check the added records. We did not add a value to the column ParentCodeID,
so this can be a good field to query: 
```
SELECT * FROM region_temp WHERE ParentCodeID IS NULL; 
```


## 2. UPDATE records

1. We can update the table, adding the parent code for these rows, with the value 
**'EU'**

```
UPDATE region_temp SET ParentCodeID = 'EU';
```
Check the result with a select:
```
SELECT * FROM region_temp; 
```
**HEADS UP!!!** Did you found anything strange? If you performed the INSERT 
statement as it is, all records will have the value **'EU'** at the ParentCodeID 
column. This is not correct!

There is no roll-back. You will need to delete the `region_temp` table, and repeat 
all steps from the beginning. To delete the table, you can use DROP:

```
DROP TABLE region_temp;
```
If you detected the error in the INSERT statement, what was the correction to make?

2. Let's do the correct UPDATE operation. First, identify the records to update with a SELECT.

```
SELECT * FROM region_temp WHERE ParentCodeID IS NULL;
```
Afterwards, we can use the WHERE condition to update only the desired records:
```
UPDATE region_temp SET ParentCodeID = 'EU' WHERE ParentCodeID IS NULL;
```
Check the result.



## 3. DELETE statements

In this case, it does not make sense to have Espanha and França as regions, 
because we will deal only with data from Portugal. We can remove that records 
from the table.

```
DELETE FROM region_temp WHERE...;
```
You need to complete the statement. Perform a select to identify the WHERE condition.

The correct statements can be:

```
DELETE FROM region_temp WHERE region_name LIKE 'Espanha';
DELETE FROM region_temp WHERE region_name LIKE 'França';
```

But if you what to do it in only one statement , then:
```
DELETE FROM region_temp WHERE region_name IN ('Espanha', 'França');
```


## 3. INSERT statements from multiple tables
It is possible to insert or update records in one table with data obtained from 
another table. We will briefly demonstrate an insert example. 

1. First, let's delete some records from `region_temp`, that we will try to recover 
later from the `region` table. Select and delete all records that correspond to the region 
level freguesia. 

```
SELECT * FROM region_temp WHERE region_level = 'freguesia';
DELETE FROM region_temp WHERE region_level = 'freguesia';
```
After deleting records, repeat the SELECT statement to confirm that records where
deleted.

2. Now we can obtain the corresponding records from the `region` table and insert
them in the `region_temp` table:

First select from the `region`:
```
SELECT * FROM region WHERE region_level = 'freguesia';
```
Then combine INSERT with SELECT
```
INSERT INTO region_temp
SELECT * FROM region WHERE region_level = 'freguesia';
```
This only works with this statement because we are sure that both tables have the
same structure. Otherwise, we would define a list of columns that would receive data.

Confirm that recods were added into the `region_temp` table:
```
SELECT * FROM region_temp WHERE region_level = 'freguesia';
```








