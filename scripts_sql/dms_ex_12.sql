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
	
/* Obtain the same values of total standard production per NUTS2 for the year 2019, 
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
	pc.`hold`
FROM
	permanent_crop pc
WHERE
	pc.`year` = 2019;


-- we need the type of crop, which is in table permanent_crop_name. 
-- We can do an INNER JOIN
SELECT
	pcn.crop_name,
	pc.`hold`
FROM
	permanent_crop pc
INNER JOIN permanent_crop_name pcn ON
	pc.pc_name_ID = pcn.pc_name_ID
WHERE
	pc.`year` = 2019;

-- repeat, but removing the 'Total' from crop type
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
INNER JOIN region r ON
	pc.NutsID = r.NutsID
INNER JOIN region_level rl ON
	r.level_ID = rl.level_ID
WHERE
	pc.`year` = 2019
	AND pcn.crop_name <> 'Total'
	AND rl.region_level = 'freguesia';

-- finally, we have to sum the holding values grouped by crop name. We will 
-- make the order descencent
SELECT
	pcn.crop_name,
	SUM(pc.`hold`) as sum_holdings
FROM
	permanent_crop pc
INNER JOIN permanent_crop_name pcn ON
	pc.pc_name_ID = pcn.pc_name_ID
INNER JOIN region r ON
	pc.NutsID = r.NutsID
INNER JOIN region_level rl ON
	r.level_ID = rl.level_ID
WHERE
	pc.`year` = 2019
	AND pcn.crop_name <> 'Total'
	AND rl.region_level = 'freguesia'
GROUP BY
	pcn.crop_name
ORDER By
	sum_holdings DESC;

-- obtain the same result, but for temporary crops
SELECT
	tcn.crop_name,
	SUM(tc.`hold`) as sum_holdings
FROM
	temporary_crop tc
INNER JOIN temporary_crop_name tcn ON
	tc.tc_name_ID = tcn.tc_name_ID
INNER JOIN region r ON
	tc.NutsID = r.NutsID
INNER JOIN region_level rl ON
	r.level_ID = rl.level_ID
WHERE
	tc.`year` = 2019
	AND tcn.crop_name <> 'Total'
	AND rl.region_level = 'freguesia'
GROUP BY
	tcn.crop_name
ORDER By
	sum_holdings DESC;

/* imagine that you want a table for all crops, that union result set from permanent 
 * crops and temporary crops. This can be done if the structure of the result 
 * set is the same, with equal number of colums, having the same order and meaning.
 * This can be done with the clause UNION, merging the two select statements of above.
 * 
 * We will add a fixed value for each select to signal if it is permanent or temporary
 * crop. We also need to remove the ORDER clause from the first select statement
 */

SELECT
	pcn.crop_name,
	'permanent' AS type_of_crop, 
	SUM(pc.`hold`) AS sum_holdings
FROM
	permanent_crop pc
INNER JOIN permanent_crop_name pcn ON
	pc.pc_name_ID = pcn.pc_name_ID
INNER JOIN region r ON
	pc.NutsID = r.NutsID
INNER JOIN region_level rl ON
	r.level_ID = rl.level_ID
WHERE
	pc.`year` = 2019
	AND pcn.crop_name <> 'Total'
	AND rl.region_level = 'freguesia'
GROUP BY
	pcn.crop_name
UNION
SELECT
	tcn.crop_name,
	'temporary' AS type_of_crop,
	SUM(tc.`hold`) AS sum_holdings
FROM
	temporary_crop tc
INNER JOIN temporary_crop_name tcn ON
	tc.tc_name_ID = tcn.tc_name_ID
INNER JOIN region r ON
	tc.NutsID = r.NutsID
INNER JOIN region_level rl ON
	r.level_ID = rl.level_ID
WHERE
	tc.`year` = 2019
	AND tcn.crop_name <> 'Total'
	AND rl.region_level = 'freguesia'
GROUP BY
	tcn.crop_name
ORDER By
	sum_holdings DESC;

-- get total area values for each temporary crop for year 2019 based on the region
-- level freguesia
SELECT
	tcn.crop_name,
	SUM(tc.area) as sum_area_ha
FROM
	temporary_crop tc
INNER JOIN temporary_crop_name tcn ON
	tc.tc_name_ID = tcn.tc_name_ID
INNER JOIN region r ON
	tc.NutsID = r.NutsID
INNER JOIN region_level rl ON
	r.level_ID = rl.level_ID
WHERE
	tc.`year` = 2019
	AND rl.region_level = 'freguesia'
	AND tcn.crop_name <> 'Total'
GROUP BY
	tcn.crop_name
ORDER BY
	sum_area_ha DESC;

/* get the sum of livestock values per animal species together with grassland holding 
 * value and area, for each year 1989, 1999, 2009 and 2019, at the municipality level.
 * Output the municipality name, year, sum of livesstock value, sum of grassland 
 + area and year
 * 
 * It is necessary to make sure that records from livestck and grassland are for
 * the same year.
 */


SELECT
	r.region_name ,
	lv.`year`,
	ln2.animal_species,
	sum(lv.value) AS livestock_value, 
	sum(g.area) AS area_ha,
	sum(g.`hold`) AS grassland_hold
FROM
	livestock lv
INNER JOIN livestock_name ln2 ON
	lv.livestock_name_ID = ln2.livestock_name_ID
INNER JOIN region r ON
	lv.NutsID = r.NutsID
INNER JOIN region_level rl ON
	r.level_ID = rl.level_ID
INNER JOIN grassland g ON
	g.NutsID = r.NutsID
WHERE
	rl.region_level = 'municipality'
	AND 
    lv.`year` = g.`year`
GROUP BY
	r.region_name,
	lv.`year`,
	ln2.animal_species;

/* get the sum of the number of familiar education per level of education  
 * for 2019, at the freguesia level, for freguesias that belong to the NUTS3 region 
 * 'Algarve.
 * Output the NUTS3 name, municipality, freguesia, year, education level and
 * sum of familiar members with that level of education.
 * 
 * Remove the education level with the value 'Total'
 */

SELECT
	r3.region_name,
	r2.region_name ,
	r.region_name,
	e.`year` ,
	el.education_level,
	sum(e.value) AS sum_education
FROM
	education e
INNER JOIN education_level el ON
	e.education_level_ID = el.education_level_ID
INNER JOIN region r ON
	e.NutsID = r.NutsID
INNER JOIN region r2 ON
	r.ParentCodeID = r2.NutsID
INNER JOIN region r3 ON
	r2.ParentCodeID = r3.NutsID
WHERE
	el.education_level <> 'Total'
	AND r.level_ID = 5
	AND r3.region_name = 'Algarve'
	AND e.`year` = 2019
GROUP BY
	r.region_name, el.education_level;

/* get the area of permanent_crop of type olive plantations and the amount of livestock of type sheep for region level freguesia*/
SELECT
	*
FROM
	livestock l
INNER JOIN permanent_crop pc ON
	l.NutsID = pc.NutsID
	AND l.`year` = pc.`year`
	WHERE ;
