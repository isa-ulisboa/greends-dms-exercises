use dms_INE;

SHOW tables;

-- query 1
SELECT * FROM permanent_crop pc ;


-- query 2
SELECT region_name, crop_name FROM permanent_crop;

-- query 3
SELECT region_name, crop_name, area FROM permanent_crop ORDER BY area ASC;

-- query 4
SELECT region_name, crop_name, area FROM permanent_crop ORDER BY area DESC;

-- query 5
SELECT * FROM permanent_crop ORDER BY area DESC LIMIT 10;

-- query 6
SELECT * FROM permanent_crop ORDER BY area DESC LIMIT 100,10;

-- query 7
SELECT count(*) FROM permanent_crop;

-- query 8
SELECT DISTINCT crop_name FROM permanent_crop; -- the orginal query in the exercise did not work, due to an error in the column name. It is "crop_name", and not "crop"

-- query 9
SELECT DISTINCT crop_name FROM permanent_crop pc LIMIT 5;


-- Q2. Repeat the SELECT statements before for table temporary_crop
-- query 1
SELECT * FROM temporary_crop pc ;

-- query 2
SELECT region_name, crop_name FROM temporary_crop;

-- query 3
SELECT region_name, crop_name, area FROM temporary_crop ORDER BY area ASC;

-- query 4
SELECT region_name, crop_name, area FROM temporary_crop ORDER BY area DESC;

-- query 5
SELECT * FROM temporary_crop ORDER BY area DESC LIMIT 10;

-- query 6
SELECT * FROM temporary_crop ORDER BY area DESC LIMIT 100,10;

-- query 7
SELECT count(*) FROM temporary_crop;

-- query 8
SELECT DISTINCT crop_name FROM temporary_crop; -- the orginal query in the exercise did not work, due to an error in the column name. It is "crop_name", and not "crop"

-- query 9
SELECT DISTINCT crop_name FROM temporary_crop pc LIMIT 5;

-- 3. Apply filters with WHERE
-- query 1
SELECT * FROM permanent_crop WHERE region_level = 'municipality';

-- query 2
SELECT * FROM permanent_crop WHERE region_level = 'municipality' AND year = 2019;

-- query 3
SELECT * FROM permanent_crop WHERE region_level = 'municipality' AND year = 2019 AND crop_name = 'Vineyards'; 

-- query 4
SELECT region_name, crop_name, area FROM permanent_crop WHERE region_level = 'municipality' AND year = 2019 AND crop_name = 'Vineyards'; 

-- query 5
SELECT region_name, crop_name, area FROM permanent_crop WHERE region_level = 'municipality' AND year = 2019 AND crop_name = 'Vineyards' ORDER BY area DESC;

-- query 6
SELECT region_name, crop_name, area FROM permanent_crop WHERE region_level = 'municipality' AND year = 2019 AND crop_name = 'Vineyards' ORDER BY area DESC LIMIT 10;

-- query 7
SELECT * FROM permanent_crop pc WHERE area = 0;

-- query 8
SELECT DISTINCT region_name FROM permanent_crop pc WHERE area = 0;

-- query 9, this is a duplication of query 7
SELECT * FROM permanent_crop pc WHERE area = 0;

-- query 10
SELECT * FROM permanent_crop WHERE region_level IN ('municipality', 'freguesia');

-- query 11
SELECT * FROM permanent_crop WHERE region_level = 'municipality' OR region_level = 'freguesia';

-- Q10. What will be the result of the following statement:
SELECT * FROM permanent_crop WHERE region_level = 'municipality' AND region_level = 'freguesia';
-- The result is empty, because it is not possible that a region is at the same time, a municipality AND a freguesia


