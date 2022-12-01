-- this script is to prepare the view perm_crop_freg and run some statements used
-- in DMS class 10

-- make sure the correct database is selected
USE dms_INE;

-- preview the table of permanent crops
SELECT * FROM permanent_crop pc ;

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

-- see the view resultset
select count(*) FROM perm_crop_freg pcf ;

-- list of non-duplicate list of municipalities, that do not contain holdings with vineyards
SELECT
	DISTINCT municipality
FROM
	perm_crop_freg pcf
WHERE
	`hold` = 0
	AND crop_name = 'Vineyards'; 

-- count number of freguesias in each municipality without vineyards. Use of GROUP BY
SELECT
	municipality, COUNT(freguesia) AS num_freg
FROM
	perm_crop_freg pcf
WHERE
	`hold` = 0
	AND crop_name = 'Vineyards'
GROUP BY municipality; 

-- sum area by municipality and crop. Exclude total from crop_name
SELECT
	municipality, crop_name, SUM(area) AS sum_area
FROM
	perm_crop_freg pcf
WHERE
	`hold` > 0 AND 
	crop_name <> 'total'
GROUP BY municipality, crop_name
HAVING sum_area > 10000
ORDER BY sum_area DESC; 

-- subquery to select frequesias with area above the average area for freguesias
-- issues an error 
SELECT
    freguesia, area
FROM
    perm_crop_freg
WHERE
    area > AVG(area);

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


