---3)

SELECT * from permanent_crop pc WHERE region_level = 'municipality';

SELECT * FROM permanent_crop pc WHERE region_level  = 'municipality' and year = 2019;

SELECT * FROM permanent_crop pc WHERE region_level  = 'municipality' and year = 2019 and crop_name = 'Vineyards';
--only strings need ''

SELECT region_name, crop_name, area from permanent_crop pc 
	WHERE region_level = 'municipality' 
		 and year = 2019 and crop_name = 'Vineyards';
		 --isto assim é boa forma de encontrar o local do erro na linha

SELECT region_name, crop_name, area 
	from permanent_crop pc
		WHERE region_level ='municipality'
			and year = 2019 
				and crop_name = 'Vineyards'order by area desc;	
			
SELECT  region_name, crop_name, area 
	from permanent_crop pc 
		where region_level ='municipality' 
			and year= 2019 and crop_name ='vineyards' 
				order by area desc limit 10;
			
SELECT * from permanent_crop pc WHERE  area = 0;

SELECT DISTINCT region_name from permanent_crop pc WHERE area =0;

select * from permanent_crop pc  WHERE area = 0;

SELECT * FROM permanent_crop pc WHERE region_level IN ('municipalaty', 'freguesia');

SELECT * FROM permanent_crop pc WHERE region_level = 'municipality' or region_level  = 'freguesia';

--12
-----noothing because the region_level can only have one be on of those 'values' 
-----diferently from the the prevoius one which could be either one or the other, selectiong both
--------after testing is more like an empty table not a nothing


			
			
			
			