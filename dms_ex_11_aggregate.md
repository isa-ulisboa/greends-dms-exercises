# Data Management and Storage

# Exercise 10 - GROUP BY and aggregate functions COUNT(), SUM(), AVG(), MIN() and MAX().

The goal of this exercise is to use aggregate functions **COUNT()**, **SUM()** , **AVG()**, **MIN()** and **MAX()** to perform calculations at the server. The full list of aggregate functions can be consulted at https://mariadb.com/kb/en/aggregate-functions/.

We will also introduce the use of **GROUP BY** to combine with these functions.

This exercise also uses the DDL statement **CREATE VIEW** to generate a table to be 
analyzed in the exercise. 

## Preparation of the exercise

This exercise is the continuation of DMS Exercise 09. It assumes you have the
`permanent_crop` table in the `dms_INE` database.

We will create a **VIEW**. VIEW is a DDL statement that corresponds to a virtual
table. It stores the result set of a query, and is updated every time it is executed.

You can use DBeaver to execute the exercise.


## 1. Create a VIEW

A VIEW is a virtual table. It is useful when a result set from a complex SELECT 
query is used repeatedly, avoiding to write it many times. In this case, we will 
use a view to obtain a table of the permanent crops, at the *freguesia* region level,
but but containing also the *municipality* to which that freguesia belongs. 

To build that view, we will use a JOIN between tables that we will discuss in later
exercises.

Analyse the following statement, and afterwards, execute it. It creates a view 
with the name `perm_crop_freg`, with several columns from the tables `permanent_crop` 
and `region`. The result is filtered to the region level of freguesia and to 
contain only values for 2019.

Execute the statement:
```
CREATE OR REPLACE
VIEW perm_crop_freg AS
SELECT
	pc.NutsID,
	pc.region_name AS freguesia,
	r1.region_name AS municipality,
	pc.crop_name ,
	pc.`year` ,
	pc.area ,
	pc.`hold`
FROM
	permanent_crop pc
INNER JOIN region r USING (NutsID) 
INNER JOIN region r1 ON r.ParentCodeID = r1.NutsID 	
WHERE
	pc.region_level = 'freguesia'
AND pc.`year` = 2019;
```

We can check the result set in the view with a SELECT, using the name of the 
view like if it was a table. 

Q.1. Complete the next statement to select all columns 
of the view:
```
SELECT ...
```
Q.2. Repeat the query, to count the number of records in the result set:
```
SELECT COUNT(*) FROM perm_crop_freg;
```
The result is the number of records in the view, which should be **24736**.

This last query used the aggregate function **COUNT()**, which we will explore in the 
continuation of the exercise. 

## 2. Create lists without duplicates

It is useful to explore the view to understand data. We can generate a list 
of the freguesias, removing duplicates:
```
SELECT DISTINCT freguesia FROM perm_crop_freg;
```
Your result should be 2871 rows.

Q.3. Do the same for municipalities and for crops:
```
-- complete the query to obtain the list of municipalities
SELECT DISTINCT ... ;

-- complete the query to obtain the list of crops
SELECT DISTINCT ... ;
```
Result: 8 rows.

## 3. GROUP BY and aggregate function COUNT()

DISTINCT allow to determine of many different values we have for a field, but it
does not provide calculations of, for example, the total of holdings for a certain
municipality of crop type.

To be able to calculate that values, we need to use GROUP BY, in combination with
the aggregate values that MySQL or MariaDB provides: COUNT(), SUM() and AVG().

1. Calculate the number of freguesias that exist in each municipality:
```
SELECT
	municipality, COUNT(freguesia) AS num_freg
FROM
	perm_crop_freg pcf
WHERE 
    crop_name = 'total'
GROUP BY municipality; 
```
Notice that we needed to filter by only one crop, in the case 'total', otherwise 
we would get the values multiplied by the number of crops.

Q.4. Using the same approach, determine the number of freguesias per municipalities 
that have holdings with crop type *Citrus plantations* (tip: you can use the number 
of holdings to determine which freguesias have citrus plantations)

```
-- write your query here:
SELECT ... ; 
```

## 4. Aggregate functions SUM(), AVG(), MIN() and MAX()

1. Calculate the total area per municipality for citrus plantations

```
SELECT
	municipality, SUM(area) AS sum_area
FROM
	perm_crop_freg pcf
WHERE
    crop_name LIKE 'Citrus%'
GROUP BY municipality; 
```

Q.5. Repeat, but for olive plantations; 
```
SELECT ...
```

Now, calculate the total number of holdings per municipality, for all crops. you can combine several fields in the GROUP BY clause. Sort the result in descending order of 
the sum of holdings. Do not forget to exclude *total* from crops). 
```
SELECT
	municipality, crop_name, SUM(`hold`) AS sum_hold
FROM
	perm_crop_freg pcf
WHERE
	crop_name <> 'total'
GROUP BY municipality, crop_name 
ORDER BY sum_hold DESC;
```
Q.6. Calculate again, but for the average (function AVG())
```
SELECT ... ;
```
Q.7. Repeat again the query, but to obtain the maximum value of holdings per municipality (function MAX())
```
SELECT ... ;
```

It is possible to filter the results using the clause HAVING. HAVING only can be applied to a result set of an aggregate function.

Let's obtain the municipalities that have the maximum of the area with citrus plantations higher than 300 ha:

```
SELECT
	municipality, crop_name, MAX(`area`) AS max_area
FROM
	perm_crop_freg pcf
WHERE
	crop_name = 'Citrus plantations'
GROUP BY municipality, crop_name 
HAVING max_area > 300
```

## 5. Combine everything together

Using the aggregate functions, you can create a summary table with descriptive 
statistics in SQL for your data:
```
SELECT
	municipality,
	crop_name,
	COUNT(`hold`) AS `count`,
	SUM(`hold`) AS `sum`,
	MIN(`hold`) AS minimum,
	MAX(`hold`) AS maximum,
	AVG(`hold`) AS average,
	STDDEV_POP(`hold`) AS std_dev
FROM
	perm_crop_freg pcf
WHERE
	crop_name <> 'total'
GROUP BY
	municipality,
	crop_name ;
```

## 6. Use of subqueries

If we want to calculate the list of freguesias which crop area is higher than the
average crop area, we can do the following query:
```
SELECT
	freguesia, area, (SELECT AVG(area) FROM perm_crop_freg pcf2) as average
FROM
	perm_crop_freg pcf
WHERE
	crop_name LIKE 'Olive%'
	AND `hold` > 0
	AND area > (SELECT AVG(area) FROM perm_crop_freg pcf2)
ORDER BY area DESC;
```
Remember that the records of the view created at the start of this exercise are 
for freguesias. Therefore, if you want to calculate average values at the 
municipality level, an aggregate function is necessary. In the previous examples
of this exercise, we achieved this using the GROUP BY clause. But we can also use
in in a subquery in the FROM clause:

```
SELECT
	municipality,
	area
FROM
	(
	SELECT
		municipality,
		AVG(area) as area
	FROM
		perm_crop_freg
	WHERE
		crop_name = 'total'
	GROUP BY
		municipality) AS municip_average;
```



## Wrap up

In this exercise we learned:
- how to create lists without duplicates;
- how to aggregate records to calculate statistics;
- how to filter results using the result of aggregate functions using HAVING;
- how to sort results using the result of aggregate functions.


This concludes this exercise. you should submit your sql script with answers via github pull request.
