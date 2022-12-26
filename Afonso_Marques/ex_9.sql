use dms_INE;


-- 1


describe region_temp;

ALTER Table region_temp  add column simple_mane VARCHAR(20);

ALTER table region_temp rename column simple_mane to simple_name;

ALTER table region_temp modify column simple_name Varchar(50);


-- 2


SELECT region_name from region_temp rt WHERE region_name like 'União%';

		-- pq que é que execuatnto o codigo anterior continua a aparecer alguma coisa?
		-- fica guardo em "metadata" ?

SELECT REPLACE (region_name, 'União das freguesias de', '') from region_temp rt  WHERE region_name  like 'União%';

SELECT region_name, REGEXP_REPLACE(region_name, 'União (.*) freguesias d[ea] ', '') From region_temp rt  WHERE region_name like 'União%';

		-- (.*) encontra os 'de' e os 'das' na linha correspondete
		-- d[ea] encontra os 'de' e 'da' depois da palavra freguesia

SELECT region_name, REGEXP_REPLACE(region_name, 'União(.*) freguesias d[ea] ', '') as short_name from region_temp WHERE region_name like 'União%';

UPDATE region_temp rt set rt.simple_name = REGEXP_REPLACE(region_name, 'União(.*) freguesias d[ea] ', '')
	where region_name  like 'União%';

		-- a entrada 615 tinha mais caracteres que os pemitidos na defenição da coluna

ALTER table region_temp modify column simple_name Varchar(150);

SELECT region_name, simple_name from region_temp rt;

update region_temp rt set rt.simple_name = rt.region_name 
	where region_name  not like 'União%';


-- 3


SELECT * from region_temp rt ;

ALTER table region_temp drop column OriginalCode;

		-- terminando assim a coluna region_name a e simple_name ficam com o memso valor

SELECT region_name from region_temp rt;

TRUNCATE table region_temp;

drop table region_temp;






