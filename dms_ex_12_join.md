# Data Management and Storage

# Exercise 12 - Working with multiple tables

The goal of this exercise is to make DML queries using multiple tables. After the 
normalization process, obtaining meaningful data from the database normally will 
require joining data from more than one table. We will use the clause **JOIN**,
in its different forms (**INNER, LEFT, RIGHT**) to get the result sets that will
allow to respond to several questions.

The ultimate goal is to obtain the tables necessary to build the dashboard of the 
[Agricultural Census](https://www.ine.pt/scripts/db_ra_2019.html).


## Preparation of the exercise

This exercise can be run at the MySQL command line or in DBeaver.

It assumes that you have your database fully normalized, as a result of the successful
completion of DMS exercise 11. If you are uncertain that the database it in good
state, you can download +https://github.com/isa-ulisboa/greends-dms-exercises/blob/main/data/dms_INE_v2.sql.zip, 
unzip it and import to your database in the operating system terminal with the command
```
$ mysql -u dms_user -p dms_INE < dms_INE_v2.sql
```  

## ER diagram of the database

The Entity-Relationship diagram of the normalized database below is useful to 
identify the relationships, helping to remember the joins needed to obtain the
relevant data

![ER diagram](./diagram/dms_INE_ER_diagram.png "ER diagram of the dms_INE database").

The metadata information about the tables is the following

| Table name | Description |
|------------|-------------|
| region  | list of regions |
| region_level | level of region (according to NUTS classification |
| education | number of familiar agricultural population per level of education |
| education_level | level of education |
| labour | agricultural labour force in annual working units |
| type_labour | type of labour force |
| production | value of total standard production (€) of agricultural holdings and average value of total standard output by hectare of utilised agricultural area (€/ ha) |
 | grassland | area of permanent grassland and meadow (ha) and number of agricultural holdings with permanent grassland and meadow |
 | livestock | number of livestock animals in agricultural holdings |
 | livestock_name | name of the animal species |
 | permanent_crop | area of permanent crops (ha) and number of agricultural holdings with permanent crops |
 | permanent_crop_name | name of the permanent crop |
 | temporary_crop | area of temporary crops (ha) and number of agricultural holdings with temporary crops |
| temporary_crop_name | name of the temporary crop |


 The unit of report is the region (geographic unit).

## 1. Implicit JOINS

1. *Obtain the values of total standard production per NUTS2 for the year 2019.*

To obtain the requested values, we need tha tables **production**, **region** and **region_level**.
 The statement would be like this, in the form of **implicit JOIN**:
```
 SELECT
	r.region_name , p.value_eur 
FROM
	production p,
	region r,
	region_level rl
WHERE
	p.NutsID = r.NutsID
	AND r.level_ID = rl.level_ID 
	AND rl.region_level = 'NUTS2'
	AND p.`year` = 2019;
```
You should get the following result:
| region_name                 |value_eur |
|----------------------------|----------|
| Norte                       |1312536063|
| Algarve                     | 373196278|
| Centro                      |1786415564|
| Área Metropolitana de Lisboa| 313163976|
| Alentejo                    |2441935279|
| Região Autónoma dos Açores  | 423978604|
| Região Autónoma da Madeira  | 107140853|

Note the use of *aliases* for the name of the tables, which make the query much 
more shorter and readable than using the full table name.

## 2. INNER JOIN

We will repeat the query, but now with the use of an **INNER JOIN**

```
SELECT
	r.region_name ,
	p.value_eur
FROM
	production p
INNER JOIN region r ON p.NutsID = r.NutsID
INNER JOIN region_level rl ON r.level_ID = rl.level_ID
WHERE
	rl.region_level = 'NUTS2'
	AND p.`year` = 2019;
```

## 3. INNER JOIN with three tables, filters and grouped by

1. *Obtain the total of agricultural holdings per type of permanent crop for year 
2019 based on the region level freguesia.*

The best approach is to divide the problem in several parts. First, get values of holdings for year 2019:

```
SELECT
	pc.`hold`
FROM
	permanent_crop pc
WHERE
	pc.`year` = 2019;
```

We need to include the type of crop, which is in table permanent_crop_name. 
We can get it with an **INNER JOIN** to the table `permanent_crop_name`:

```
SELECT
	pcn.crop_name,
	pc.`hold`
FROM
	permanent_crop pc
INNER JOIN permanent_crop_name pcn ON
	pc.pc_name_ID = pcn.pc_name_ID
WHERE
	pc.`year` = 2019;
```
We should remove the results for the 'Total' crop type, which is an aggregate 
value of the other crops.

```
SELECT
	pcn.crop_name,
	pc.`hold`
FROM
	permanent_crop pc
INNER JOIN permanent_crop_name pcn ON
	pc.pc_name_ID = pcn.pc_name_ID
WHERE
	pc.`year` = 2019
AND pcn.crop_name <> 'Total';
```

The result show values for all region. That is why each crop has many values.
We need to define the level `freguesia`, which requires to join `region` and 
`region_level` tables:
```
SELECT
	pcn.crop_name,
	pc.`hold`
FROM
	permanent_crop pc
INNER JOIN permanent_crop_name pcn ON
	pc.pc_name_ID = pcn.pc_name_ID
INNER JOIN region r ON pc.NutsID = r.NutsID 
INNER JOIN region_level rl ON r.level_ID = rl.level_ID 
WHERE
	pc.`year` = 2019
AND pcn.crop_name <> 'Total'
AND rl.region_level = 'freguesia';
```

Finally, we have to sum the holding values grouped by crop name. Add the function
SUM to the value of holdings, and add the clause GROUP BY on crop names. We will
also display the values in decreasing order.
```
SELECT
	pcn.crop_name,
	SUM(pc.`hold`) as sum_holdings
FROM
	permanent_crop pc
INNER JOIN permanent_crop_name pcn ON
	pc.pc_name_ID = pcn.pc_name_ID
INNER JOIN region r ON pc.NutsID = r.NutsID 
INNER JOIN region_level rl ON r.level_ID = rl.level_ID 
WHERE
	pc.`year` = 2019
AND pcn.crop_name <> 'Total'
AND rl.region_level = 'freguesia'
GROUP BY pcn.crop_name
ORDER By sum_holdings DESC;
```

Q.1. Now, you can make the same query, but for temporary crops. We will need to change
table names and field names, but the structure of the query should be the same.

```
-- Write your code here ...
```


## 4. **UNION** two queries
1. *Obtain the total of agricultural holdings for all types of crops (permanent 
or temporary) for year 2019 based on the region level freguesia. Identify is the
crop is permanent or temporary in the result.*

Imagine that you want a table with the value of before for all crops, including 
permanent and temporary crops. This can be achieved by merging the two previous 
queries with the clause **UNION**.

It can only be done if the structure of the result set is the same, with equal number 
of columns, having the same order and meaning. The clause **UNION** merges two select statements.

In the previous SELECT queries, we will add a fixed value for each select to 
identify if it is permanent or temporary crop. We also need to remove the ORDER 
clause from the first select statement.

```
SELECT
	pcn.crop_name,
	'permanent' AS type_of_crop, 
	SUM(pc.`hold`) AS sum_holdings
FROM
	permanent_crop pc
INNER JOIN permanent_crop_name pcn ON
	pc.pc_name_ID = pcn.pc_name_ID
INNER JOIN region r ON pc.NutsID = r.NutsID 
INNER JOIN region_level rl ON r.level_ID = rl.level_ID 
WHERE
	pc.`year` = 2019
AND pcn.crop_name <> 'Total'
AND rl.region_level = 'freguesia'
GROUP BY pcn.crop_name
UNION
SELECT
	tcn.crop_name,
	'temporary' AS type_of_crop,
	SUM(tc.`hold`) AS sum_holdings
FROM
	temporary_crop tc
INNER JOIN temporary_crop_name tcn ON
	tc.tc_name_ID = tcn.tc_name_ID
INNER JOIN region r ON tc.NutsID = r.NutsID 
INNER JOIN region_level rl ON r.level_ID = rl.level_ID 
WHERE
	tc.`year` = 2019
AND tcn.crop_name <> 'Total'
AND rl.region_level = 'freguesia'
GROUP BY tcn.crop_name
ORDER By sum_holdings DESC;
```

