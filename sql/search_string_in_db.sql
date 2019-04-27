-- Your values
SET @table_schema = '';
SET @condition = "LIKE '%%'";
SET @column_types_regexp = '^((var)?char|(var)?binary|blob|text|enum|set)\\(';

-- Reset @sql_query in case it was used previously
SET @sql_query = '';

-- Build query for each table and merge with previous queries with UNION
SELECT
    -- Use `DISTINCT IF(QUERYBUILDING, NULL, NULL)`
    -- to only select a single null value
    -- instead of selecting the query over and over again as it's built
    DISTINCT IF(@sql_query := CONCAT(
        IF(LENGTH(@sql_query), CONCAT(@sql_query, " UNION "), ""),
        'SELECT ',
            QUOTE(CONCAT('`', `table_name`, '`.`', `column_name`, '`')), ' AS `column`, ',
            'COUNT(*) AS `occurrences` ',
        'FROM `', `table_schema`, '`.`', `table_name`, '` ',
        'WHERE `', `column_name`, '` ', @condition
    ), NULL, NULL) `query`
FROM (
    SELECT
        `table_schema`,
        `table_name`,
        `column_name`
    FROM `information_schema`.`columns`
    WHERE `table_schema` = @table_schema
    AND `column_type` REGEXP @column_types_regexp
) `results`;
select @sql_query;

-- Only return results with at least one occurrence
SET @sql_query = CONCAT("SELECT * FROM (", @sql_query, ") `results` WHERE `occurrences` > 0");

-- Run built query
PREPARE statement FROM @sql_query;
EXECUTE statement;
DEALLOCATE PREPARE statement;