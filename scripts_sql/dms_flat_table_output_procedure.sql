use dms_INE_v2;

/* 
We will create a flat table for the level freguesia. When a table has many different
categories (crops, livestock, etc...), too many combinations
result from joining tables. We will create pivot tables as views, to make columns 
for each category.

This is based on https://arctype.com/blog/mysql-pivot-table/

*/

-- Set GROUP_CONTACT Max Length to increase max number of characters in the query
SET
  SESSION group_concat_max_len = 100000;

-- 1. Transform table permanent crops
-- Create GROUP_CONTACT Statement
SET
  @sql = (
    SELECT
      GROUP_CONCAT (
        DISTINCT CONCAT(
          "SUM(CASE WHEN pcn.crop_name = '",
          pcn.crop_name,
          "' THEN pc.area ELSE 0 END) AS '",
          pcn.crop_name,
          "'"
        )
      )
    FROM
      permanent_crop pc INNER JOIN permanent_crop_name pcn ON pc.pc_name_ID = pcn.pc_name_ID 
      inner join region r on pc.NutsID = r.NutsID
    WHERE
	    r.level_ID = 5
    AND
      pcn.crop_name <> 'Total' 
);
-- Create the Complete SQL Statement
SET
  @pivot_statement = CONCAT(
    "CREATE OR REPLACE VIEW permanent_crop_view AS SELECT pc.NutsID, pc.`year`,",
    @sql,
    " FROM permanent_crop pc 
        INNER JOIN permanent_crop_name pcn ON pc.pc_name_ID = pcn.pc_name_ID 
        inner join region r on pc.NutsID = r.NutsID
    WHERE
	    r.level_ID = 5 GROUP BY pc.NutsID, pc.`year`"
  );
 

-- Prepare and Execute
PREPARE complete_pivot_statment
FROM
  @pivot_statement;
EXECUTE complete_pivot_statment;
DEALLOCATE PREPARE complete_pivot_statment;

select * from permanent_crop_view;

-- 2. Transform table permanent crops holdings
-- Create GROUP_CONTACT Statement
SET
  @sql = (
    SELECT
      GROUP_CONCAT (
        DISTINCT CONCAT(
          "SUM(CASE WHEN pcn.crop_name = '",
          pcn.crop_name,
          "' THEN pc.hold ELSE 0 END) AS '",
          pcn.crop_name,
          "'"
        )
      )
    FROM
      permanent_crop pc INNER JOIN permanent_crop_name pcn ON pc.pc_name_ID = pcn.pc_name_ID 
      inner join region r on pc.NutsID = r.NutsID
    WHERE
	    r.level_ID = 5
    AND
      pcn.crop_name <> 'Total' 
);
-- Create the Complete SQL Statement
SET
  @pivot_statement = CONCAT(
    "CREATE OR REPLACE VIEW permanent_crop_hold_view AS SELECT pc.NutsID, pc.`year`,",
    @sql,
    " FROM permanent_crop pc 
        INNER JOIN permanent_crop_name pcn ON pc.pc_name_ID = pcn.pc_name_ID 
        inner join region r on pc.NutsID = r.NutsID
    WHERE
	    r.level_ID = 5 GROUP BY pc.NutsID, pc.`year`"
  );
 

-- Prepare and Execute
PREPARE complete_pivot_statment
FROM
  @pivot_statement;
EXECUTE complete_pivot_statment;
DEALLOCATE PREPARE complete_pivot_statment;

select * from permanent_crop_hold_view;


-- 3. Transform table temporary crops
-- Create GROUP_CONTACT Statement
SET
  @sql = (
    SELECT
      GROUP_CONCAT (
        DISTINCT CONCAT(
          "SUM(CASE WHEN tcn.crop_name = '",
          tcn.crop_name,
          "' THEN tc.area ELSE 0 END) AS '",
          tcn.crop_name,
          "'"
        )
      )
    FROM
      temporary_crop tc INNER JOIN temporary_crop_name tcn ON tc.tc_name_ID = tcn.tc_name_ID 
      INNER JOIN region r ON tc.NutsID = r.NutsID
    WHERE
	    r.level_ID = 5
    AND
      tcn.crop_name <> 'Total' 
);
-- Create the Complete SQL Statement
SET
  @pivot_statement = CONCAT(
    "CREATE OR REPLACE VIEW temporary_crop_view AS SELECT tc.NutsID, tc.`year`,",
    @sql,
    " FROM temporary_crop tc 
        INNER JOIN temporary_crop_name tcn ON tc.tc_name_ID = tcn.tc_name_ID 
        INNER JOIN region r ON tc.NutsID = r.NutsID
    WHERE
	    r.level_ID = 5 GROUP BY tc.NutsID, tc.`year`"
  );
 

-- Prepare and Execute
PREPARE complete_pivot_statment
FROM
  @pivot_statement;
EXECUTE complete_pivot_statment;
DEALLOCATE PREPARE complete_pivot_statment;

select * from temporary_crop_view;


-- 4. Transform table temporary crops
-- Create GROUP_CONTACT Statement
SET
  @sql = (
    SELECT
      GROUP_CONCAT (
        DISTINCT CONCAT(
          "SUM(CASE WHEN tcn.crop_name = '",
          tcn.crop_name,
          "' THEN tc.hold ELSE 0 END) AS '",
          tcn.crop_name,
          "'"
        )
      )
    FROM
      temporary_crop tc INNER JOIN temporary_crop_name tcn ON tc.tc_name_ID = tcn.tc_name_ID 
      INNER JOIN region r ON tc.NutsID = r.NutsID
    WHERE
	    r.level_ID = 5
    AND
      tcn.crop_name <> 'Total' 
);
-- Create the Complete SQL Statement
SET
  @pivot_statement = CONCAT(
    "CREATE OR REPLACE VIEW temporary_crop_hold_view AS SELECT tc.NutsID, tc.`year`,",
    @sql,
    " FROM temporary_crop tc 
        INNER JOIN temporary_crop_name tcn ON tc.tc_name_ID = tcn.tc_name_ID 
        INNER JOIN region r ON tc.NutsID = r.NutsID
    WHERE
	    r.level_ID = 5 GROUP BY tc.NutsID, tc.`year`"
  );
 

-- Prepare and Execute
PREPARE complete_pivot_statment
FROM
  @pivot_statement;
EXECUTE complete_pivot_statment;
DEALLOCATE PREPARE complete_pivot_statment;

select * from temporary_crop_hold_view;

-- 5. Transform table education
-- Create GROUP_CONTACT Statement
SET
  @sql = (
    SELECT
      GROUP_CONCAT (
        DISTINCT CONCAT(
          "SUM(CASE WHEN el.education_level = '",
          el.education_level,
          "' THEN e.value ELSE 0 END) AS '",
          el.education_level,
          "'"
        )
      )
    FROM
      education e INNER JOIN education_level el ON e.education_level_ID = el.education_level_ID 
      INNER JOIN region r ON e.NutsID = r.NutsID
    WHERE
	    r.level_ID = 5
    AND
      el.education_level <> 'Total' 
);
-- Create the Complete SQL Statement
SET
  @pivot_statement = CONCAT(
    "CREATE OR REPLACE VIEW education_view AS SELECT e.NutsID, e.`year`,",
    @sql,
    " FROM education e 
        INNER JOIN education_level el ON e.education_level_ID = el.education_level_ID 
        INNER JOIN region r ON e.NutsID = r.NutsID
    WHERE
	    r.level_ID = 5 GROUP BY e.NutsID, e.`year`"
  );
 

-- Prepare and Execute
PREPARE complete_pivot_statment
FROM
  @pivot_statement;
EXECUTE complete_pivot_statment;
DEALLOCATE PREPARE complete_pivot_statment;

select * from education_view;


-- 6. Transform table livestock
-- Create GROUP_CONTACT Statement
SET
  @sql = (
    SELECT
      GROUP_CONCAT (
        DISTINCT CONCAT(
          "SUM(CASE WHEN ln2.animal_species= '",
          ln2.animal_species,
          "' THEN l.value ELSE 0 END) AS '",
          ln2.animal_species,
          "'"
        )
      )
    FROM
      livestock l INNER JOIN livestock_name ln2 ON l.livestock_name_ID = ln2.livestock_name_ID 
      INNER JOIN region r ON l.NutsID = r.NutsID
    WHERE
	    r.level_ID = 5
);
-- Create the Complete SQL Statement
SET
  @pivot_statement = CONCAT(
    "CREATE OR REPLACE VIEW livestock_view AS SELECT l.NutsID, l.`year`,",
    @sql,
    " FROM livestock l 
        INNER JOIN livestock_name ln2 ON l.livestock_name_ID = ln2.livestock_name_ID 
        INNER JOIN region r ON l.NutsID = r.NutsID
    WHERE
	    r.level_ID = 5 GROUP BY l.NutsID, l.`year`"
  );
 

-- Prepare and Execute
PREPARE complete_pivot_statment
FROM
  @pivot_statement;
EXECUTE complete_pivot_statment;
DEALLOCATE PREPARE complete_pivot_statment;

select * from livestock_view;



-- 7. Transform table labour
-- Create GROUP_CONTACT Statement
SET
  @sql = (
    SELECT
      GROUP_CONCAT (
        DISTINCT CONCAT(
          "SUM(CASE WHEN tl.type_labour = '",
          tl.type_labour,
          "' THEN l.value ELSE 0 END) AS '",
          tl.type_labour,
          "'"
        )
      )
    FROM
      labour l INNER JOIN type_labour tl ON l.type_labour_ID  = tl.type_labour_ID 
      INNER JOIN region r ON l.NutsID = r.NutsID
    WHERE
	    r.level_ID = 5
	AND tl.type_labour NOT LIKE 'Total%'
);
-- Create the Complete SQL Statement
SET
  @pivot_statement = CONCAT(
    "CREATE OR REPLACE VIEW labour_view AS SELECT l.NutsID, l.`year`,",
    @sql,
    " FROM labour l 
        INNER JOIN type_labour tl ON l.type_labour_ID = tl.type_labour_ID 
        INNER JOIN region r ON l.NutsID = r.NutsID
    WHERE
	    r.level_ID = 5 GROUP BY l.NutsID, l.`year`"
  );
 

-- Prepare and Execute
PREPARE complete_pivot_statment
FROM
  @pivot_statement;
EXECUTE complete_pivot_statment;
DEALLOCATE PREPARE complete_pivot_statment;

select * from labour_view;

-- create flat table
-- create flat table
SELECT 	
	r.NutsID,
	RIGHT(r.NutsID, 6) as DICOFRE,
	r.region_name ,
	e.`year` ,
  e.`None` as edu_none,
	e.Basic as edu_basic,
	e.`Secondary / post-secondary` as edu_secondary,
	e.Superior as edu_superior ,
	l.`Family labour force` as labour_family,
	l.Holder as labour_holder,
	l.Spouse as labour_spouse,
	l.`Other family members` as labour_other_family,  
	l.`Non-family labour force` as labour_non_family,
	l.Regular as labour_regular,  
	l.`Non-regular` as labour_non_regular,
	l.`Workers not hired by the holder` as labour_not_hired,
	p.value_eur as production_eur,
	p.area_ha as production_area,
	l2.Cattle as livestock_cattle,
	l2.Pigs as livestock_pigs,  
	l2.Sheep as livestock_sheep,  
	l2.Goats as livestock_goats,
	l2.Equidae as livestock_equidae,
	l2.Poultry as livestock_poultry,
	l2.Rabbits as livestock_rabbits,
	l2.`Inhabited hives and traditional cork hives` as livestock_hives,
	g.area as grassland_area,
	g.`hold` as grassland_holdings,
	tc.Cereals as cereals_area,
	tc.`Dried pulses` as dried_pulses_area,
	tc.`Temporary grasses and grazings` as grasses_area,  
	tc.`Fodder plants` as fodder_area, 
  tc.Potatoes as potatoes_area,
	tc.Sugarbeets as sugarbeets_area, 
	tc.`Industrial crops` as industrial_crops_area,  
	tc.`Fresh vegetables` as fresh_veg_area,  
	tc.`Flowers and ornamental plants` as flowers_area,
	tc.`Other temporary crops` as other_temp_crops_area,
	tch.Cereals as cereals_area,
	tch.`Dried pulses` as dried_pulses_area,
	tch.`Temporary grasses and grazings` as grasses_area,  
	tch.`Fodder plants` as fodder_area, 
  tch.Potatoes as potatoes_area,
	tch.Sugarbeets as sugarbeets_area, 
	tch.`Industrial crops` as industrial_crops_area,  
	tch.`Fresh vegetables` as fresh_veg_area,  
	tch.`Flowers and ornamental plants` as flowers_area,
	tch.`Other temporary crops` as other_temp_crops_area,  
	pc.`Fresh fruit plantations (excluding citrus plantations)` as fresh_fruit_area,
	pc.`Citrus plantations` as citrus_area,  
	pc.`Fruit plantations (subtropical climate zones)` as fruit_area,
	pc.`Nuts plantations` as nuts_area,
	pc.`Olive plantations`  as olive_area,
	pc.Vineyards as vineyards_area,
	pc.`Other permanent crops` as other_permanent_crop_area ,
  pch.`Fresh fruit plantations (excluding citrus plantations)` as fresh_fruit_holdings,
  pch.`Citrus plantations` as citrus_holdings,  
  pch.`Fruit plantations (subtropical climate zones)` as fruit_holdings,
  pch.`Nuts plantations` nuts_holdings,
  pch.`Olive plantations` as olive_holdings,
  pch.Vineyards as vineyard_holdings,
  pch.`Other permanent crops` as other_permanent_crop_holdings
FROM
	education_view e
INNER JOIN region r ON
	e.NutsID = r.NutsID
INNER JOIN region_level rl ON
	r.level_ID = rl.level_ID
INNER JOIN labour_view l ON
	e.NutsID = l.NutsID
	AND e.`year` = l.`year`
LEFT JOIN production p ON
	e.NutsID = p.NutsID
	AND e.`year` = p.`year`
INNER JOIN livestock_view l2 ON
	e.NutsID = l2.NutsID
	AND e.`year` = l2.`year`
INNER JOIN grassland g ON
	e.NutsID = g.NutsID
	AND e.`year` = g.`year`
INNER JOIN temporary_crop_view tc ON
	e.NutsID = tc.NutsID
	AND e.`year` = tc.`year`
INNER JOIN temporary_crop_hold_view tch ON
	e.NutsID = tch.NutsID
	AND e.`year` = tch.`year`
INNER JOIN permanent_crop_view pc ON
	e.NutsID = pc.NutsID
	AND e.`year` = pc.`year`
INNER JOIN permanent_crop_hold_view pch ON
	e.NutsID = pch.NutsID
	AND e.`year` = pch.`year`
WHERE
	rl.region_level = 'freguesia'
	AND r.NutsID NOT LIKE '200%'  -- exclui Açores 
	AND r.NutsID NOT LIKE '300%';  -- exclui Madeira

