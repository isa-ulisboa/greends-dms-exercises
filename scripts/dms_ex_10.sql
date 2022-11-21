-- DMS exercise 10, aggregate functions 

-- make sure the correct database is selected
USE dms_INE;

-- create a view to make further analysis easier
-- filters on year=2019 and region_level=freguesia
-- adds the parent region municipality
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

-- see the result set of the 
SELECT * from perm_crop_freg pcf ;

-- obtain a list of freguesias
SELECT DISTINCT freguesia FROM perm_crop_freg;

-- obtain a list of municipalities
SELECT DISTINCT municipality FROM perm_crop_freg;

-- obtain a list of crops
SELECT DISTINCT crop_name FROM perm_crop_freg;

-- number of freguesias per municipality
SELECT
	municipality, COUNT(freguesia) AS num_freg
FROM
	perm_crop_freg pcf
WHERE 
    crop_name = 'total'
GROUP BY municipality; 


-- obtain number of freguesias per municipality with citrus plantations
SELECT
	municipality, COUNT(freguesia) AS num_freg
FROM
	perm_crop_freg pcf
WHERE
	`hold` > 0
	AND crop_name LIKE 'Citrus%'
GROUP BY municipality; 

-- obtain the total area per municipility for citrus plantations
SELECT
	municipality, SUM(area) AS sum_area
FROM
	perm_crop_freg pcf
WHERE
    crop_name LIKE 'Citrus%'
GROUP BY municipality; 

-- obtain the total area per municipility for each of the crops, exclude 'total' from crops 
SELECT
	municipality, crop_name, SUM(area) AS sum_area
FROM
	perm_crop_freg pcf
WHERE
	crop_name <> 'total'
GROUP BY municipality, crop_name ;

-- obtain the total number of holdings per municipility for each of the crops, 
-- exclude 'total' from crops 
SELECT
	municipality, crop_name, SUM(`hold`) AS sum_hold
FROM
	perm_crop_freg pcf
WHERE
	crop_name <> 'total'
GROUP BY municipality, crop_name ;


-- obtain the average of holdings per municipility for each of the crops, 
-- exclude 'total' from crops, and order by average area in descend order
SELECT
	municipality, crop_name, AVG(`hold`) AS avg_hold
FROM
	perm_crop_freg pcf
WHERE
	crop_name <> 'total'
GROUP BY municipality, crop_name 
ORDER BY avg_hold DESC;

-- obtain the municipalities that have the maximum of the area with citrus plantations 
-- higher than 300 ha
SELECT
	municipality, crop_name, MAX(`area`) AS max_area
FROM
	perm_crop_freg pcf
WHERE
	crop_name = 'Citrus plantations'
GROUP BY municipality, crop_name 
HAVING max_area > 300;


-- obtain the maximum number of holdings per municipility for each of the crops, 
-- exclude 'total' from crops 
SELECT
	municipality, crop_name, MAX(`hold`) AS max_hold
FROM
	perm_crop_freg pcf
WHERE
	crop_name <> 'total'
GROUP BY municipality, crop_name ;

-- create a summary statistics table
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

-- subquery to select frequesias with area above the average area for freguesias
SELECT
	freguesia, area, (SELECT AVG(area) FROM perm_crop_freg pcf2) as average
FROM
	perm_crop_freg pcf
WHERE
	crop_name LIKE 'Olive%'
	AND `hold` > 0
	AND area > (SELECT AVG(area) FROM perm_crop_freg pcf2)
ORDER BY area DESC;

-- subquery to select municipalities with area above the average area for municipalities
-- the subquery is in FROM
SELECT
	municipality,
	area
FROM
	(
	SELECT
		municipality,
		AVG(area) as area
	FROM
		perm_crop_freg pcf
	WHERE
		crop_name = 'total'
	GROUP BY
		municipality) AS municip_average;


