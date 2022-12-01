

-- this script supported presentation of DMS class 11

-- make use dms_INE is the active db
USE dms_INE;

-- select region
SELECT NutsID , `Level`, region_name, region_level  FROM region;
-- select permanent_crop
SELECT NutsID, region_name, crop_name, `year` , area , `hold`  FROM permanent_crop pc ;

-- subquery to get crops for regions of level 5
SELECT NutsID, region_name, crop_name, `year`, area, `hold`
FROM
	permanent_crop c
WHERE
    crop_name <> 'Total' AND
	NutsID IN (SELECT NutsID FROM region r WHERE `level` = 5);

-- subquery to get regions where exists citrus plantations
SELECT
	NutsID, region_name
FROM
	region
WHERE  
	`level` = 5 AND
	NutsID IN 
	(SELECT NutsID FROM permanent_crop pc WHERE crop_name LIKE 'Citrus%');

-- full implicit join
SELECT * FROM region, permanent_crop;


-- full implicit join with restrictions
SELECT * FROM region, permanent_crop WHERE region.NutsID = permanent_crop.NutsID ;

-- with aliases
SELECT * FROM region r, permanent_crop pc WHERE r.NutsID = pc.NutsID ;

-- tidy table
SELECT r.NutsID, r.region_name , r.`Level`, pc.crop_name , pc.`year` , pc.area  FROM region r, permanent_crop pc WHERE r.NutsID = pc.NutsID ;

SELECT r.NutsID, r.region_name , r.`Level`, pc.crop_name , pc.`year` , pc.area  FROM region r LEFT JOIN permanent_crop pc ON r.NutsID = pc.NutsID AND 
r.`Level` = 4 and pc.region_level = 'freguesia' OR pc.region_level = 'municipality';

show tables;

show databases;

use demo_dms_2022;

select * from region r

SELECT DISTINCT NutsID, region_name  from region r where region_level = 'NUST2'  


-- table with region level NUTS2
DROP TABLE IF EXISTS region_temp;

CREATE TEMPORARY TABLE region_temp
SELECT NutsID, region_name , region_level  FROM region r where region_level = 'NUST2';

SELECT * FROM region_temp;

-- table some rows of NUTS2 and NUTS 3
DROP TABLE IF EXISTS permanent_crop_temp;

CREATE TEMPORARY TABLE permanent_crop_temp
SELECT NutsID, crop_name, `year` , area , `hold` FROM permanent_crop pc WHERE NutsID IN ('11', '111', '16', '16D') and `year` = 2019 and (crop_name LIKE 'Citrus%' OR crop_name LIKE 'Vine%');

SELECT * FROM permanent_crop_temp ;
-- INNER JOIN 
SELECT
	r.NutsID as nuts1,
	pc.NutsID as nuts2,
	r.region_name,
	pc.crop_name,
	pc.`year`,
	pc.area,
	pc.`hold`
FROM
	region_temp r
INNER JOIN permanent_crop_temp pc;
-- the query above can be repeated for LEFT and RIGHT JOIN
 