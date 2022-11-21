-- make sure the correct database is selected
USE dms_INE;

-- preview the table of permanent crops
SELECT * FROM permanent_crop pc ;

-- create a view to make further analysis easier
-- filters on year=2019, crop=Vineyards and region_level=freguesia
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
select * FROM perm_crop_freg pcf ;

-- list of freguesias
SELECT DISTINCT freguesia  FROM perm_crop_freg pcf WHERE area = 0 AND crop_name = 'Vineyards'; 

SELECT DISTINCT municipality, COUNT(freguesia)  from perm_crop_freg pcf  WHERE area = 0 AND crop_name = 'Vineyards' GROUP BY municipality ; 

SELECT municipality, count(municipality) as num_freguesias FROM perm_crop_freg pcf GROUP BY municipality;

SELECT * FROM perm_crop_freg pcf ;

