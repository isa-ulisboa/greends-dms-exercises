---1

SELECT * FROM permanent_crop;

SELECT region_name, crop_name from permanent_crop;

select region_name, crop_name, area from permanent_crop order by area asc;

select region_name, crop_name, area from permanent_crop order by area desc;

select * from permanent_crop pc order by area desc limit 10;

select * from permanent_crop pc  order by area desc limit 101,10;

SELECT COUNT(*) From permanent_crop pc;

SELECT DISTINCT crop_name  from permanent_crop;

SELECT DISTINCT crop_name from permanent_crop pc limit 5



