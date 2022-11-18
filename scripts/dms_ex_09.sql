-- Ensure dms_INE is the current database
use dms_INE;

-- See the current structure of the table;
DESCRIBE region_temp;

-- Alter a table adding a column
ALTER TABLE region_temp ADD COLUMN simple_mane VARCHAR(20);

-- Change the name of the column
ALTER TABLE region_temp RENAME COLUMN simple_mane TO simple_name;

-- Change the column type
ALTER TABLE region_temp MODIFY COLUMN simple_name VARCHAR(50);

-- select freguesias starting by 'união'
SELECT region_name, simple_name FROM region_temp WHERE region_name LIKE 'União%'; 

-- replace the 'união...' by an empty string
SELECT region_name, REGEXP_REPLACE (region_name, 'União (.*) freguesias d[ea] ', '') short_name
FROM region_temp WHERE region_name LIKE 'União%'; 

-- update the column simple_name
UPDATE region_temp rt SET rt.simple_name = REGEXP_REPLACE (region_name, 'União (.*) freguesias d[ea] ', '') 
WHERE region_name LIKE 'União%';

-- select 
SELECT region_name, simple_name FROM region_temp rt ;

-- add region values when name does not start by União
UPDATE region_temp rt SET rt.simple_name = rt.region_name 
WHERE region_name NOT LIKE 'União%';

-- drop column in table
ALTER TABLE region_temp DROP COLUMN OriginalCode;

-- select
SELECT * FROM region_temp rt;

-- truncate table
TRUNCATE TABLE region_temp;

-- drop table
DROP TABLE region_temp;



