# Data Management and Storage

# Exercise 8 - SELECT statement

The goal of this exercise is to exercise SQL statements with **SELECT**.

> Your solutions for this exercise should be submitted via Moodle. You should create a SQL script with solution queries identified as **Q**.The deadline for submissions is **24th October 2025**.

## Preparation of the exercise

**Note**: please refer to exercise *dms_ex_06* to check how to do the following two steps.

1. Create a new database named `dms_INE`, and import data from the sql backup file dms_INE.zip, that can be downloaded from https://github.com/isa-ulisboa/greends-dms-exercises/blob/main/data/dms_INE.zip. Do not forget to unzip the downloaded file.

2. Give privileges to `dms_user` to the `dms_INE` you just created.

3. Open DBeaver and open a connection to your local MariaDB installation

## 1. Select columns

1. Select all columns from table `permanent_crop`:

```SQL
SELECT * FROM permanent_crop;
```

2. Select only columns *region_name* and *crop_name* from table `permanent_crop`:

```SQL
SELECT region_name, crop_name FROM permanent_crop;
```
3. Select columns *region_name*, *crop_name* and *area* from table `permanent_crop`, with ascending order:

```SQL
SELECT region_name, crop_name, area FROM permanent_crop ORDER BY area ASC;
```

4. Select columns *region_name*, *crop_name* and *area* from table `permanent_crop`, with descending order on *area*:

```SQL
SELECT region_name, crop_name, area FROM permanent_crop ORDER BY area DESC;
```

5. Select all columns from table `permanent_crop`, with descending order on *area*, but show only first 10 rows:

```SQL
SELECT * FROM permanent_crop ORDER BY area DESC LIMIT 10;
```

6. Select all columns from table `permanent_crop`, with descending order on *area*, but show only 10 rows after row 100:

```SQL
SELECT * FROM permanent_crop ORDER BY area DESC LIMIT 100,10;
```

7. Count the number of rows in table `permanent_crop`:

```SQL
SELECT count(*) FROM permanent_crop;
```

8. Create a list of unique values of the crops in `permanent_crop`:

```SQL
SELECT DISTINCT crop FROM permanent_crop;
```
  If you copied the last statement above, you probably received an error message. Check the error and provide the right statement.

9. Create a list of unique values of the crops in `permanent_crop`, but show only the first 5:


```SQL
-- Q1. Write your statement here
SELECT ... 
```

## 2. Repeat the SELECT exercises for other tables

Q2. Repeat the SELECT statements before for table `temporary_crop`

## 3. Apply filters with WHERE

1. Select all columns of the table `permanent_crop` but only for the region_level `municipality`:
```SQL
SELECT * FROM permanent_crop WHERE region_level = 'municipality';
```

2. Select all columns of the table `permanent_crop` but only for the region_level `municipality` and year 2019:
```SQL
SELECT * FROM permanent_crop WHERE region_level = 'municipality' and year = 2019;
```
3. Select all columns of the table `permanent_crop` but only for the region_level `municipality`, year `2019` and the crop `Vineyards`:
```SQL
-- Q3. Write your statement here
SELECT * FROM permanent_crop WHERE ...
```
4. Select columns *region_name*, *crop_name* and *area* of the table but only for the region_level `municipality`, year `2019` and the crop `Vineyards`:

```SQL
-- Q4. Write your statement here
SELECT ... 
```
5. Select columns *region_name*, *crop_name* and *area* of the table `permanent_crop` but only for the region_level `municipality`, year `2019` and the crop `Vineyards`, in descending order of *area*:
```SQL
-- Q5. Write your statement here
SELECT ... 
```
6. Select area TOP 10 of the table `permanent_crop`, with columns *region_name*, *crop_name* and *area*  but only for the region_level `municipality`, year `2019` and the crop `Vineyards`, in descending order of *area*:
```SQL
-- Q6. Write your statement here
SELECT ... 
```
7. Select all columns of the table `permanent_crop` where area is zero:
```SQL
-- Q7. Write your statement here
SELECT ...
```

8. Select a list of regions (the column `region_name`), without duplications, of the table `permanent_crop` where area is zero:
```SQL
-- Q8. Write your statement here
SELECT ...
```

9. Select all columns of the table `permanent_crop` where area is zero:
```SQL
-- Q9. Write your statement here
SELECT ...
```
10. Select all columns of the table `permanent_crop` where region level is `municipality` or `freguesia`:
```SQL
SELECT * FROM permanent_crop WHERE region_level IN ('municipality', 'freguesia');
```

11. We can repeat the result of before in a other way:
```SQL
SELECT * FROM permanent_crop WHERE region_level = 'municipality' OR region_level = 'freguesia';
```

12. Q10. What will be the result of the following statement:
```SQL
SELECT * FROM permanent_crop WHERE region_level = 'municipality' AND region_level = 'freguesia';
```
Justify your answer:

> ## 4. Submission of exercise
> **Submit one file**:
> 1. Submit the sql script you created with queries or answers to questions identified with `Q`, including the question number. If the response is not a SQL statement, comment your text using `--`for a single row, or `/*`and `*/` to open and close your comment section. 
> 
> The submission in Moodle is at [Exercise 8 submission](https://elearning.ulisboa.pt/mod/assign/view.php?id=541521).