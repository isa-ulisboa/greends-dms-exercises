use dms_INE;

-- Set GROUP_CONTACT Max Length
SET
  SESSION group_concat_max_len = 100000;
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
      permanent_crop pc INNER JOIN permanent_crop_name pcn ON pc.pc_name_ID = pcn.pc_name_ID inner join region r on pc.NutsID = r.NutsID
    WHERE
	r.level_ID = 5
);
-- Create the Complete SQL Statement
SET
  @pivot_statement = CONCAT(
    "CREATE OR REPLACE VIEW permanent AS SELECT pc.NutsID, pc.`year`,",
    @sql,
    " FROM permanent_crop pc INNER JOIN permanent_crop_name pcn ON pc.pc_name_ID = pcn.pc_name_ID inner join region r on pc.NutsID = r.NutsID
    WHERE
	r.level_ID = 5 GROUP BY pc.NutsID, pc.`year`"
  );
 

-- Prepare and Execute
PREPARE complete_pivot_statment
FROM
  @pivot_statement;
EXECUTE complete_pivot_statment;
DEALLOCATE PREPARE complete_pivot_statment;


select * from permanent;