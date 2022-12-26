use dms_INEv2;

SELECT 
	r.region_name, p.value_eur
	from
		production p ,
		region r ,
		region_level rl 
	where
		p.NutsID = r.NutsID 
		and r.level_ID  = rl.level_ID 
		and rl.region_level  = 'NUTS2'
		and p.`year`  = 2019;
		

	
SELECT 
	r.region_name,
	p.value_eur
	from
		production p 
	inner join region r  on p.NutsID  = r.NutsID 
	INNER JOIN region_level rl  ON r.level_ID = rl.level_ID 
	where 
		rl.region_level  = 'NUTS2'
		and p.`year` = 2019;
		

SELECT
	pc.`hold`
	from
		permanent_crop pc 
	WHERE
		pc.`year` = 2019;
	
	
	
SELECT 
	pcn.crop_name,
	pc.`hold`
	from
		permanent_crop pc 
	inner join permanent_crop_name pcn ON
		pc.pc_name_ID  = pcn.pc_name_ID 
	where
		pc.`year`  = 2019
	And pcn.crop_name <> 'Total';
	


SELECT pcn.crop_name, pc.`hold`
	from
		permanent_crop pc 
	inner join permanent_crop_name pcn on pc.pc_name_ID  = pcn.pc_name_ID 
	INNER JOIN region r on pc.NutsID = r.NutsID 
	INNER JOIN region_level rl on r.level_ID = rl.level_ID 
	WHERE 
		pc.`year` = 2019
		and pcn.crop_name  <> 'Total'
		and rl.region_level = 'freguesia';
	

SELECT pcn.crop_name, Sum(pc.`hold`) as sum_holdings
	from 
		permanent_crop pc 
	inner join permanent_crop_name pcn on pc.pc_name_ID = pcn.pc_name_ID 
	INNER JOIN region r on pc.NutsID = r.NutsID 
	INNER JOIN region_level rl on r.level_ID = rl.level_ID
	WHERE 
		pc.`year`  = 2019
	AND pcn.crop_name <> 'Total'
	and rl.region_level  = 'freguesia'
	group by pcn.crop_name 
	order by sum_holdings desc;


-- Q1


SELECT tcn.crop_name, Sum(tc.`hold`) as sum_holdings
	from 
		temporary_crop tc
	inner join temporary_crop_name tcn on tc.tc_name_ID = tcn.tc_name_ID 
	INNER JOIN region r on tc.NutsID = r.NutsID 
	INNER JOIN region_level rl on r.level_ID = rl.level_ID
	WHERE 
		tc.`year`  = 2019
	AND tcn.crop_name <> 'Total'
	and rl.region_level  = 'freguesia'
	group by tcn.crop_name 
	order by sum_holdings desc;


SELECT
	pcn.crop_name,
	'permanent' AS type_of_crop, 
	SUM(pc.`hold`) AS sum_holdings
FROM
	permanent_crop pc
INNER JOIN permanent_crop_name pcn ON
	pc.pc_name_ID = pcn.pc_name_ID
INNER JOIN region r ON pc.NutsID = r.NutsID 
INNER JOIN region_level rl ON r.level_ID = rl.level_ID 
WHERE
	pc.`year` = 2019
AND pcn.crop_name <> 'Total'
AND rl.region_level = 'freguesia'
GROUP BY pcn.crop_name
UNION
SELECT
	tcn.crop_name,
	'temporary' AS type_of_crop,
	SUM(tc.`hold`) AS sum_holdings
FROM
	temporary_crop tc
INNER JOIN temporary_crop_name tcn ON
	tc.tc_name_ID = tcn.tc_name_ID
INNER JOIN region r ON tc.NutsID = r.NutsID 
INNER JOIN region_level rl ON r.level_ID = rl.level_ID 
WHERE
	tc.`year` = 2019
AND tcn.crop_name <> 'Total'
AND rl.region_level = 'freguesia'
GROUP BY tcn.crop_name
ORDER By sum_holdings DESC;
 



-- Q2

describe temporary_crop;

SELECT tcn.crop_name, sum(tc.`area`) as sum_area
	from temporary_crop tc
		inner join temporary_crop_name tcn on tc.tc_name_ID = tcn.tc_name_ID 
	INNER JOIN region r on tc.NutsID = r.NutsID 
	INNER JOIN region_level rl on r.level_ID = rl.level_ID
	WHERE 
		tc.`year`  = 2019
	AND tcn.crop_name <> 'Total'
	and rl.region_level  = 'freguesia'
	group by tcn.crop_name 
	order by sum_area desc;
	
-- Q3

describe livestock;
describe livestock_name;

select * from livestock;

sELECT
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


-- Q4

SELECT * from education ;

SELECT r3.region_name,
	r2.region_name,
	r.region_name,
	e.`year`,
	el.education_level,
	sum(e.value) as sum_education
	
from 
	education e 
inner  join education_level el ON e.education_level_ID = el.education_level_ID
inner join region r on e.NutsID = r.NutsID
INNER join region r2 on r.ParentCodeID = r2.NutsID
INNER join region r3 on r2.ParentCodeID = r3.NutsID
WHERE 
	el.education_level  <> 'Total'
	and r.Level_ID = 5
	and r3.region_name  = 'Algarve'
	and e.`year` = 2019
GROUP By 
	r.region_name , el.education_level ;



