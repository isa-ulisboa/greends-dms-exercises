-- define dms_INE as the active database
use dms_INE;

-- show all tables
show tables;

-- query to otain all fields from all tables, at freguesia level
SELECT
	r.NutsID,
	RIGHT(r.NutsID, 6) as DICOFRE,
	r.region_name as freguesia,
	e.`year`,
	el.education_level ,
	e.value as education_value,
	tl.type_labour ,
	l.value as labour_value,
	p.value_eur as production_value_eur,
	p.area_ha as production_area_ha,
	ln2.animal_species as livestock_annimal,
	l2.value as livestock_value,
	g.`hold` as grassland_holdings,
	g.area as grassland_area,
	tcn.crop_name as temporary_crop,
	tc.`hold` as temporary_crop_holdings,
	tc.area as temporary_crop_area,
	pcn.crop_name as permanent_crop,
	pc.`hold` as permanent_crop_holdings,
	pc.area as permanent_crop_area
FROM
	education e
INNER JOIN region r ON
	e.NutsID = r.NutsID
INNER JOIN region_level rl ON
	r.level_ID = rl.level_ID
INNER JOIN education_level el ON
	e.education_level_ID = el.education_level_ID
INNER JOIN labour l ON
	e.NutsID = l.NutsID
	AND e.`year` = l.`year`
INNER JOIN type_labour tl ON
	l.type_labour_ID = tl.type_labour_ID
LEFT JOIN production p ON
	e.NutsID = p.NutsID
	AND e.`year` = p.`year`
INNER JOIN livestock l2 ON
	e.NutsID = l2.NutsID
	AND e.`year` = l2.`year`
INNER JOIN livestock_name ln2 ON
	l2.livestock_name_ID = ln2.livestock_name_ID
INNER JOIN grassland g ON
	e.NutsID = g.NutsID
	AND e.`year` = g.`year`
INNER JOIN temporary_crop tc ON
	e.NutsID = tc.NutsID
	AND e.`year` = tc.`year`
INNER JOIN temporary_crop_name tcn ON
	tc.tc_name_ID = tcn.tc_name_ID
INNER JOIN permanent_crop pc ON
	e.NutsID = pc.NutsID
	AND e.`year` = pc.`year`
INNER JOIN permanent_crop_name pcn ON
	pc.pc_name_ID = pcn.pc_name_ID
WHERE
	rl.region_level = 'freguesia'
	AND r.NutsID NOT LIKE '200%'  -- exclui Madeira 
	AND r.NutsID NOT LIKE '300%'  -- exclui Açores
	AND el.education_level <> 'Total'
	AND tcn.crop_name NOT LIKE 'Total'
	AND pcn.crop_name NOT LIKE 'Total'
	AND r.NutsID LIKE '111160101%';

	
select DISTINCT NutsID from region;
SELECT
	count(*)
FROM
	education e
INNER JOIN region r ON
	e.NutsID = r.NutsID
INNER JOIN region_level rl ON
	r.level_ID = rl.level_ID
INNER JOIN education_level el ON
	e.education_level_ID = el.education_level_ID
INNER JOIN labour l ON
	e.NutsID = l.NutsID
	AND e.`year` = l.`year`
INNER JOIN type_labour tl ON
	l.type_labour_ID = tl.type_labour_ID
LEFT JOIN production p ON
	e.NutsID = p.NutsID
	AND e.`year` = p.`year`
INNER JOIN livestock l2 ON
	e.NutsID = l2.NutsID
	AND e.`year` = l2.`year`
INNER JOIN livestock_name ln2 ON
	l2.livestock_name_ID = ln2.livestock_name_ID
INNER JOIN grassland g ON
	e.NutsID = g.NutsID
	AND e.`year` = g.`year`
INNER JOIN temporary_crop tc ON
	e.NutsID = tc.NutsID
	AND e.`year` = tc.`year`
INNER JOIN temporary_crop_name tcn ON
	tc.tc_name_ID = tcn.tc_name_ID
INNER JOIN permanent_crop pc ON
	e.NutsID = pc.NutsID
	AND e.`year` = pc.`year`
INNER JOIN permanent_crop_name pcn ON
	pc.pc_name_ID = pcn.pc_name_ID
WHERE
	rl.region_level = 'freguesia'
	AND r.NutsID NOT LIKE '200%'  -- exclui Madeira 
	AND r.NutsID NOT LIKE '300%'  -- exclui Açores
	AND el.education_level <> 'Total'
	AND tl.type_labour LIKE 'Total%'
	AND tcn.crop_name NOT LIKE 'Total'
	AND pcn.crop_name LIKE 'Total';
	AND r.NutsID LIKE '11116%';
	
select * from livestock_name ln2 ;

select * from permanent_crop_name pcn ;

select * from permanent_crop pc ;


SELECT
	pc.NutsID,
	pc.`year` ,
	SUM(CASE 
		WHEN pcn.crop_name LIKE 'Fresh fruit plant%' THEN pc.area 
		ELSE 0
	END) as fresh_fruit_area,
	SUM(CASE 
		WHEN pcn.crop_name LIKE 'Citrus plant%' THEN area 
		ELSE 0
	END) as citrus_area,
	SUM(CASE 
		WHEN pcn.crop_name LIKE 'Fresh plant%' THEN area 
		ELSE 0
	END) as fruit_area,
	SUM(CASE 
		WHEN pcn.crop_name LIKE 'Nuts plant%' THEN area 
		ELSE 0
	END) as nuts_area,
	SUM(CASE 
		WHEN pcn.crop_name LIKE 'Olive plant%' THEN area 
		ELSE 0
	END) as olive_area,
	SUM(CASE 
		WHEN pcn.crop_name LIKE 'Viney%' THEN area 
		ELSE 0
	END) as vineyard_area,
	SUM(CASE 
		WHEN pcn.crop_name LIKE 'Other%' THEN area 
		ELSE 0
	END) as other_area	
from
	permanent_crop pc
inner join region r on
	pc.NutsID = r.NutsID
inner join permanent_crop_name pcn on
	pc.pc_name_ID = pcn.pc_name_ID
WHERE
	r.level_ID = 5
	and pcn.crop_name <> 'Total'
group by pc.NutsID, pc.`year`;


