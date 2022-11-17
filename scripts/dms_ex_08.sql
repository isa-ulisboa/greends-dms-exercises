-- Ensure dms_INE is the current database
use dms_INE;

-- Create a copy of the table region
CREATE TABLE region_temp
SELECT
	*
FROM
	region r ;

-- Insert values
INSERT
	INTO region_temp (NutsID, `Level`, OriginalCode, region_name, region_level)
VALUES 
    ('PT',0,'PT','Portugal','country');
   
-- Check record was inserted
SELECT * FROM region_temp WHERE region_name = 'Portugal'; 

-- Add two new rows at once
INSERT INTO region_temp 
    (NutsID, `Level`, OriginalCode, region_name,region_level)
  VALUES 
    ('ES', 0, 'ES', 'Espanha', 'country'),
    ('FR', 0, 'FR', 'França', 'country');
   
describe region_temp;

-- Check all new records. We did not add a value to the column ParentCodeID,
-- so this can be a good field to query
SELECT * FROM region_temp WHERE ParentCodeID IS NULL ; 

-- do the update
UPDATE region_temp SET ParentCodeID = 'EU' WHERE ParentCodeID IS NULL;

-- Check the result
SELECT * FROM region_temp WHERE ParentCodeID = 'EU'; 

-- delete records
DELETE FROM region_temp WHERE region_name IN ('Espanha', 'França');

-- select and delete records where region_level is freguesia
SELECT * FROM region_temp WHERE region_level = 'freguesia';
DELETE FROM region_temp WHERE region_level = 'freguesia';

-- get the records from table region 
SELECT * FROM region_temp WHERE region_level = 'freguesia';

-- combine insert with select
INSERT INTO region_temp
SELECT * FROM region WHERE region_level = 'freguesia';


   
