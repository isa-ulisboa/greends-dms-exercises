-- use dms_INE
use dms_INE;

/* 1.1. Obtain the total area of agricultural land (SAU) for Portugal. We will assume that this is the sum of 
 * the area with temporary crops and permanent crops
 */

-- need to define which region level to use 
SELECT * FROM region_level rl;

-- we will make two subqueries and sum results
SELECT
	(
(
	SELECT
		-- area sum for temporary crops. We need to make joins to region_level, through region
		SUM(area)
	FROM
		temporary_crop tc
	INNER JOIN region r ON
		tc.NutsID = r.NutsID
	INNER JOIN region_level rl ON
		r.level_ID = rl.level_ID
	WHERE
		tc.year = 2019
		AND rl.region_level = 'NUTS1') +
(
	SELECT
		-- area sum for permanent crops. We need to make joins to region_level, through region
		SUM(area)
	FROM
		permanent_crop pc
	INNER JOIN region r ON
		pc.NutsID = r.NutsID
	INNER JOIN region_level rl ON
		r.level_ID = rl.level_ID
	WHERE
		pc.year = 2019
		AND rl.region_level = 'NUTS1')) as total;

	
	
	

/* 1.2. Obtain the variation of the area in percentage between 2009 and 2019.
 */
SELECT
	year,
	sum(area) as total_area
from
	(
	SELECT
		-- area sum for temporary crops. We need to make joins to region_level, through region
		tc.year,
		SUM(area) as area
	FROM
		temporary_crop tc
	INNER JOIN region r ON
		tc.NutsID = r.NutsID
	INNER JOIN region_level rl ON
		r.level_ID = rl.level_ID
	WHERE
		tc.year >= 2009
		AND rl.region_level = 'NUTS1'
	GROUP BY
		tc.`year`
UNION
	SELECT
		-- area sum for temporary crops. We need to make joins to region_level, through region
		pc.year,
		SUM(area) as area
	FROM
		permanent_crop pc
	INNER JOIN region r ON
		pc.NutsID = r.NutsID
	INNER JOIN region_level rl ON
		r.level_ID = rl.level_ID
	WHERE
		pc.year >= 2009
		AND rl.region_level = 'NUTS1'
	GROUP BY
		pc.`year`
	) as combined
GROUP BY
	year;


select * from grassland g 
/*
 * 1.3 Average area per farm
 */

SELECT
	SUM(sum_area),
	SUM(sum_holdings),
	SUM(sum_area) DIV SUM(sum_holdings) AS avg_area_per_farm
from
	(
	SELECT
		sum(area) AS sum_area,
		sum(hold) AS sum_holdings
	FROM
		permanent_crop pc
	INNER JOIN region r ON
		pc.NutsID = r.NutsID
	INNER JOIN region_level rl ON
		r.level_ID = rl.level_ID
	WHERE
		`year` = 2019
		AND rl.region_level = 'country'
UNION
	SELECT
		sum(area) AS sum_area,
		sum(hold) AS sum_holdings
	from
		temporary_crop tc
	inner join region r ON
		tc.NutsID = r.NutsID
	INNER JOIN region_level rl ON
		r.level_ID = rl.level_ID
	WHERE
		`year` = 2019
		AND rl.region_level = 'country'
) AS combined;


/*
 * 2.1. Obtain the number of farms with permanent crops
 * */

-- See how to identify permanent crops
SELECT * FROM permanent_crop_name pcn ;

-- See how to determine the number of farms
SELECT * FROM permanent_crop pc ;

-- calculate at country level
SELECT
	pcn.crop_name , r.region_name, SUM(pc.`hold`) as number_farms 
FROM
	permanent_crop pc
INNER JOIN region r ON
	pc.NutsID = r.NutsID
INNER JOIN region_level rl ON
	r.level_ID = rl.level_ID 
INNER JOIN permanent_crop_name pcn ON pc.pc_name_ID = pcn.pc_name_ID 
WHERE pcn.crop_name <> 'Total' AND rl.region_level = 'country' AND pc.year = 2019
GROUP BY r.region_name, pcn.crop_name  
ORDER BY number_farms DESC;

 

			
		