
-- 1

use dms_INE;

select * from permanent_crop pc ;

SELECT * from region r ;

		-- só para ver a s tabelas

CREATE or REPLACE 
	view perm_crop_freg as
	select
		pc.NutsID,
		pc.region_name as freguesia,
		r1.region_name as municipality,
		pc.crop_name,
		pc.`year`,
		pc.area,
		pc.`hold`
	from
		permanent_crop pc 
	inner join region r using (NutsID)
	Inner join region r1 on r.ParentCodeID = r1.NutsID 
	WHERE 
		pc.region_level  = 'freguesia'
	AND pc.`year` = 2019;

SELECT * from perm_crop_freg pcf;

select COUNT(*) from perm_crop_freg pcf;


-- 2


SELECT DISTINCT freguesia from perm_crop_freg pcf;

SELECT COUNT(DISTINCT freguesia) from perm_crop_freg pcf ;

select DISTINCT municipality from perm_crop_freg pcf ;

SELECT COUNT(DISTINCT municipality) from perm_crop_freg pcf ;

SELECT DISTINCT crop_name from perm_crop_freg pcf;

SELECT COUNT(DISTINCT crop_name) from perm_crop_freg pcf;


-- 3


SELECT 
		municipality, COUNT(freguesia) as num_freg
	from
		perm_crop_freg pcf 
	WHERE 
		crop_name = 'total'
	GROUP BY municipality;

SELECT 
		municipality, count (freguesia) as num_freg_citrus
	from
		perm_crop_freg pcf 
	WHERE 
		crop_name = 'Citrus plantations' and `hold` > 0
	GROUP  by municipality ;


-- 4


SELECT 
		municipality, SUM(area) as sum_area
	from
		perm_crop_freg pcf 
	WHERE 
		crop_name  like 'Citrus%'
	GROUP BY municipality;

SELECT 
		municipality, SUM(area) as sum_area
	from
		perm_crop_freg pcf 
	WHERE 
		crop_name like 'Olive%'
	GROUP BY municipality;

SELECT 
		municipality, crop_name, sum(`hold`) as sum_hold
	from
		perm_crop_freg pcf 
	WHERE 
		crop_name <> 'total'
	group by municipality, crop_name
	order by sum_hold DESC;

SELECT 
		municipality, crop_name, AVG(`hold`) as sum_hold
	from
		perm_crop_freg pcf 
	WHERE 
		crop_name <> 'total'
	group by municipality, crop_name
	order by sum_hold DESC;

SELECT 
		municipality, crop_name, Max(`hold`) as sum_hold
	from
		perm_crop_freg pcf 
	WHERE 
		crop_name <> 'total'
	group by municipality, crop_name
	order by sum_hold DESC;

SELECT 
		municipality, crop_name, MAX(`area`) as max_area
	from
		perm_crop_freg pcf 
	WHERE 
		crop_name like 'Citrus%'
	GROUP by municipality, crop_name
	having max_area > 300;


-- 5


SELECT 
		municipality,
		crop_name,
		COUNT(`hold`) as `count`,
		SUM(`hold`) as `sum`,
		MIN(`hold`) as minimum,
		MAX(`hold`) as maximum,
		AVG(`hold`) as average,
		stddev_pop(`hold`) as std_dev
	from
		perm_crop_freg pcf 
	WHERE 
		crop_name <> 'total'
	Group BY 
		municipality ,
		crop_name ;
	

-- 6
	
	
SELECT 
		freguesia, area, (SELECT AVg(area) from perm_crop_freg pcf2) as average
	from
		perm_crop_freg pcf 
	WHERE 
		crop_name like 'Olive%'
		AND `hold` > 0
		and area > (SELECT AVG(area) from perm_crop_freg pcf2 )
	Order by area DESC;

SELECT 
		municipality,
		area
	from
		(
		select
			municipality,
			aVG(area) as area
		from
			perm_crop_freg pcf
		WHERE
			crop_name= 'total'
		GROUP BY
			municipality) as municip_average;
			