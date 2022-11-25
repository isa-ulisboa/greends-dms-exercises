# Data Management and Storage

# Exercise 9 - ALTER, TRUNCATE and DROP (DDL statements)

The goal of this exercise is to exercise DLL SQL statements with **ALTER**, 
**TRUNCATE** and **DROP** statements.

We will also introduce the use of **ALIASES** for columns and tables.

## Preparation of the exercise

This exercise is the continuation of DMS Exercise 08. It assumes you have the
`region_temp` table in the `dms_INE` database.

You can use DBeaver to execute the exercise.


## 1. ALTER table

We can use the SQL **ALTER** statement to make changes in the structure of a table, 
like adding, removing, renaming or modifying columns.

1. Check the current schema of the table:
```
DESCRIBE region_temp;
```

Use this all the times you want to check changes in the schema of a table;

2. Create a new column in the `region_temp` table.

```
ALTER TABLE region_temp ADD COLUMN simple_mane VARCHAR(20);
```

2. Rename a column. There is a typo in the name of the column. Let's modify it:

```
ALTER TABLE region_temp RENAME COLUMN simple_mane TO simple_name;
```

3. We can also change the column type.

```
ALTER TABLE region_temp MODIFY COLUMN simple_name VARCHAR(50);
```

## 2. Add values to the new column

We will now fill in the column with a simplified name of the region. This is 
relevant for the freguesias which name starts with `União das freguesias...`

1. First, identify those records starting by that string:

```
SELECT region_name FROM region_temp WHERE region_name LIKE 'União%'; 
```
2. Then, let's try with the MySQL function **REPLACE**. 

The generic form of the function is:

REPLACE (*string*, *substring*, *new_string*)

To know more about the functions of MySQL, you can check the [following resource](https://www.w3schools.com/mysql/mysql_ref_functions.asp).

We will replace `União das freguesias de ` by an empty string, to shorten the name.
Execute the statement:

```
SELECT REPLACE (region_name, 'União das freguesias de ', '') FROM region_temp WHERE region_name LIKE 'União%'; 
```
However, if you check the outcome, there are situations that are not captured, like

`União das freguesias da `

`União de freguesias de `

We have variations in the propositions `de`, `da`, `das` in two different parts of 
the string. Therefore, this seems to be a good case to use [**Regular Expressions**](https://en.wikipedia.org/wiki/Regular_expression). Regular expressions (also called **regex**) 
are expressions to define a search pattern in a string. They are very useful when
dealing with text data.

In this case, we can use them to solve the search problem of the `de`, `da`, `das`.

Try the following statement:

```
SELECT region_name, REGEXP_REPLACE (region_name, 'União (.*) freguesias d[ea] ', '') FROM region_temp WHERE region_name LIKE 'União%';  
```
In the statement, `(.*)` finds the first `de` and `das` occurrence in the string,
and `d[ea]` finds the second `de` and `da`, after the word `freguesias`.

The output gives two columns, one with the original name, and another with the shorten
name. 

3. Use of aliases

In the previous query, the name of the second column is too long and strange to understand.

To solve that, we can use `aliases`:
- to create an `alias`, we use the keyword **`AS`**. 
- We can use `aliases` in SQL both for columns and for tables
- An alias is temporary, only for the duration of the query
- It allows to write shorter statements, and also to make SQL statements
more readable.

Therefore, we can repeat the statement adding the alias `short_name`.
```
SELECT region_name, REGEXP_REPLACE (region_name, 'União (.*) freguesias d[ea] ', '') AS short_name FROM region_temp WHERE region_name LIKE 'União%';  
```

4. Add values with an update

We can, finally, add the shorten values to the new column. Notice how the UPDATE query 
is build. It uses an alias for the table name (the AS keyword can be omitted):
```
UPDATE region_temp rt SET rt.simple_name = REGEXP_REPLACE (region_name, 'União (.*) freguesias d[ea] ', '') 
WHERE region_name LIKE 'União%';
```
The query will not work. There will be an error issued:

```
SQL Error [1406] [22001]: (conn=8) Data too long for column 'simple_name' at row XXX
```
Can you identify the reason of the error?

5. Solve the issue 'Data too long'

Yes, the reason for the error is because the column `simple_name` only allows up to 
50 characters (see 1.3 above). Therefore, we need to modify it to accommodate more 
characters.

Do that using the ALTER statement of above, and try the UPDATE query again. 

6. Finish the job

Do a SELECT statement to output columns `region_name` and `simple_name` for all records to
check the current situation. 
```
SELECT ...
```
You will verify that for records which `region_name` 
does not start by 'União', the `simple_name` column contains a **NULL** value, 
as expected. 

Therefore, we need to repeat the UPDATE statement for that cases. Can you try to 
write the statement?
```
UPDATE ...
```
## 3. Final SQL DDL statements
Remove the column `OriginalCode`, because it is redundant with the `NutsID`.
```
ALTER TABLE region_temp DROP COLUMN OriginalCode;
```

And as this is a table we used only for the exercise, we can use it to test 
TRUNCATE and DROP statements. Remember that these SQL DDL delete records and 
delete the table, respectively.
```
TRUNCATE TABLE region_temp;
```

```
DROP TABLE region_temp;
```







