---2)

SELECT * from permanent_crop pc ;

SELECT region_name, crop_name from permanent_crop pc ;

SELECT region_name, crop_name, area from permanent_crop pc order by area asc;

select region_name, crop_name, area from permanent_crop order by area DESC ;

SELECT * from permanent_crop pc  order by area desc limit 10;

SELECT * from permanent_crop pc  order by area desc limit 100,10;

SELECT  COUNT(*) from permanent_crop pc; 

SELECT DISTINCT crop_name from permanent_crop pc ;

SELECT DISTINCT crop_name from permanent_crop pc limit 5;


