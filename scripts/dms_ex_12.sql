-- use dms_INE
use dms_INE;

/* Obtain the values of total standard production per NUTS2 for the year 2019, 
 * using implicit JOIN
 */

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
	
/* Obtain the values of total standard production per NUTS2 for the year 2019, 
 * using INNER JOIN
 */

SELECT
	r.region_name ,
	p.value_eur
FROM
	production p
INNER JOIN region r ON
	p.NutsID = r.NutsID
INNER JOIN region_level rl ON
	r.level_ID = rl.level_ID
WHERE
	rl.region_level = 'NUTS2'
	AND p.`year` = 2019;

/* 
 * Obtain the total of agricultural holdings per type of permanent crop for year 2019
 * based on the region level freguesia
 */

-- Let's divide the problem in several parts. First, get values of holdings for year 2019
SELECT
	*
FROM
	permanent_crop pc
WHERE
	pc.`year` = 2019;

-- repeat, obtaining only the column of interest
SELECT
	pc.`hold`
FROM
	permanent_crop pc
WHERE
	pc.`year` = 2019;

-- we need the type of crop, which is in table permanent_crop_name. We can do an INNER JOIN
SELECT
	pcn.crop_name,
	pc.`hold`
FROM
	permanent_crop pc
INNER JOIN permanent_crop_name pcn ON
	pc.pc_name_ID = pcn.pc_name_ID
WHERE
	pc.`year` = 2019;

-- the result show values for all region. That is why each crop has many values.
-- we need to define the level freguesia, which requires to join region and region_level
-- tables
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
AND rl.region_level = 'freguesia';

-- the result of the query above includes 'Total' as a crop, which does not make sense.
-- we need to exclude it
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
AND rl.region_level = 'freguesia'
AND pcn.crop_name <> 'Total';

-- finally, we have to sum the holding values grouped by crop name
SELECT
	pcn.crop_name,
	SUM(pc.`hold`)
FROM
	permanent_crop pc
INNER JOIN permanent_crop_name pcn ON
	pc.pc_name_ID = pcn.pc_name_ID
INNER JOIN region r ON pc.NutsID = r.NutsID 
INNER JOIN region_level rl ON r.level_ID = rl.level_ID 
WHERE
	pc.`year` = 2019
AND rl.region_level = 'freguesia'
AND pcn.crop_name <> 'Total'
GROUP BY pcn.crop_name;

-- get total area values for each temporary crop for year 2019 based on the region
-- level freguesia
SELECT
	tcn.crop_name,
	SUM(tc.area)
FROM
	temporary_crop tc
INNER JOIN temporary_crop_name tcn ON
	tc.tc_name_ID = tcn.tc_name_ID
INNER JOIN region r ON tc.NutsID = r.NutsID 
INNER JOIN region_level rl ON r.level_ID = rl.level_ID 
WHERE
	tc.`year` = 2019
AND rl.region_level = 'freguesia'
AND tcn.crop_name <> 'Total'
GROUP BY tcn.crop_name;



