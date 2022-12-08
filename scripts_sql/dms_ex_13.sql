USE dms_INE;


/* Obtain the number of total annual working unit (AWU) for municipalities 
 * that have the area of vineyeards higher than 10 ha, for year 2019. List 
 * the municipality name, year, area
 */
SELECT
	r.region_name,
	pc.year,
	pc.area
FROM
	permanent_crop pc
INNER JOIN permanent_crop_name pcn
ON
	pc.pc_name_ID = pcn.pc_name_ID
INNER JOIN region r ON
	pc.NutsID = r.NutsID
INNER JOIN labour l ON
	r.NutsID = l.NutsID
INNER JOIN type_labour tl ON
	l.type_labour_ID = tl.type_labour_ID
WHERE
	crop_name = 'Vineyards'
	AND r.level_ID = 4
	AND pc.year = l.year
	AND tl.type_labour LIKE 'Total%'
	AND pc.area > 10
ORDER BY
	pc.area DESC;
	

/* Obtain the number of holdings with permanent crop per type of crop
 * at the NUTS2 level for year 2019 
 */

SELECT
	pcn.crop_name ,
	SUM(pc.`hold`) AS sum_holdings
FROM
	permanent_crop pc
INNER JOIN permanent_crop_name pcn
ON
	pc.pc_name_ID = pcn.pc_name_ID
INNER JOIN region r ON
	pc.NutsID = r.NutsID
WHERE
	pc.`year` = 2019
	AND 
r.level_ID = 2
	AND pcn.crop_name <> 'Total'
GROUP BY
	pcn.pc_name_ID
ORDER BY
	sum_holdings DESC ;
