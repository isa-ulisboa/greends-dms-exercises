# Data Management and Storage

# Exercise 7 - SELECT statement

The goal of this exercise is to exercise SQL statements with **SELECT**.

## Preparation of the exercise

**Note**: please refer to exercise *dms_ex_04* to check how to do the following two steps.

1. Create a new database named `dms_INE`, and import data from the sql backup file dms_INE.zip, that can be downloaded from https://github.com/isa-ulisboa/greends-dms-exercises/blob/main/data/dms_INE.zip. Do not forget to unzip the downloaded file.

2. Give privileges to `dms_user` to the `dms_INE` you just created.

3. Open DBeaver and open a connection to your local MariaDB installation

## 1. Select columns

1. Select all columns from table `permanent_crop`:

```
SELECT * FROM permanent_crop;
```

2. Select only columns *region_name* and *crop_name* from table `permanent_crop`:

```
SELECT region_name, crop_name FROM permanent_crop;
```
3. Select columns *region_name*, *crop_name* and *area* from table `permanent_crop`, with ascending order:

```
SELECT region_name, crop_name, area FROM permanent_crop ORDER BY area ASC;
```

4. Select columns *region_name*, *crop_name* and *area* from table `permanent_crop`, with descending order on *area*:

```
SELECT region_name, crop_name, area FROM permanent_crop ORDER BY area DESC;
```

5. Select all columns from table `permanent_crop`, with descending order on *area*, but show only first 10 rows:

```
SELECT * FROM permanent_crop ORDER BY area DESC LIMIT 10;
```

6. Select all columns from table `permanent_crop`, with descending order on *area*, but show only 10 rows after row 100:

```
SELECT * FROM permanent_crop ORDER BY area DESC LIMIT 100,10;
```

7. Count the number of rows in table `permanent_crop`:

```
SELECT count(*) FROM permanent_crop;
```

8. Create a list of unique values of the crops in `permanent_crop`:

```
SELECT DISTINCT crop FROM permanent_crop;
```
  If you copied the last statement above, you probably received an error message. Check the error and provide the right statement.

8. Create a list of unique values of the crops in `permanent_crop`, but show only the first 5:

```
-- Write your statement here
SELECT ... 
```

## 2. Repeat the SELECT exercises for other tables

Repeat the SELECT statements before for table `temporary_crop`

## 3. Apply filters with WHERE

1. Select all columns of the table `permanent_crop` but only for the region_level `municipality`:
```
SELECT * FROM permanent_crop WHERE region_level = 'municipality';
```

2. Select all columns of the table `permanent_crop` but only for the region_level `municipality` and year 2019:
```
SELECT * FROM permanent_crop WHERE region_level = 'municipality' and year = 2019;
```
3. Select all columns of the table `permanent_crop` but only for the region_level `municipality`, year `2019` and the crop `Vineyards`:
```
-- Write your statement here
SELECT * FROM permanent_crop WHERE ...
```
4. Select columns *region_name*, *crop_name* and *area* of the table but only for the region_level `municipality`, year `2019` and the crop `Vineyards`:

```
-- Write your statement here
SELECT ... 
```
5. Select columns *region_name*, *crop_name* and *area* of the table `permanent_crop` but only for the region_level `municipality`, year `2019` and the crop `Vineyards`, in descending order of *area*:
```
-- Write your statement here
SELECT ... 
```
6. Select area TOP 10 of the table `permanent_crop`, with columns *region_name*, *crop_name* and *area*  but only for the region_level `municipality`, year `2019` and the crop `Vineyards`, in descending order of *area*:
```
-- Write your statement here
SELECT ... 
```
7. Select all columns of the table `permanent_crop` where area is zero:
```
-- Write your statement here
SELECT ...
```

8. Select a list of regions (the column `region_name`), without duplications, of the table `permanent_crop` where area is zero:
```
-- Write your statement here
SELECT ...
```
9. Select all columns of the table `permanent_crop` where area is zero:
```
SELECT ...
```

10. Select all columns of the table `permanent_crop` where region level is `municipality` or `freguesia`:
```
SELECT * FROM permanent_crop WHERE region_level IN ('municipality', 'freguesia');
```
11. We can repeat the result of before in a other way:
```
SELECT * FROM permanent_crop WHERE region_level = 'municipality' OR region_level = 'freguesia';
```

12. What will be the result of the following statement:
```
SELECT * FROM permanent_crop WHERE region_level = 'municipality' AND region_level = 'freguesia';
```
Justify your answer: