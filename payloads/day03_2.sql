CREATE OR REPLACE TABLE part0 AS (
    SELECT *
    FROM (
        SELECT
            regexp_split_to_table(content, '(don\''t\(\)|do\(\))') AS extract_content,
            contains(content, concat('do()', extract_content)) AS is_do,
            contains(content, concat('don''t()', extract_content)) AS is_dont
        FROM read_text('datasets/day03.txt')
    )
    WHERE is_do OR (NOT is_do AND NOT is_dont)
);


CREATE OR REPLACE TABLE part1 AS (
    SELECT unnest(regexp_extract_all(extract_content, '(mul\(\d+,\d+\))')) AS mul
    FROM part0
);

CREATE OR REPLACE TABLE part2 AS (
    SELECT regexp_extract(mul, '(\d+),(\d+)', ['x', 'y']) AS digits
    FROM part1
);

SELECT sum(digits.x::INTEGER * digits.y::INTEGER) AS result -- noqa: RF01
FROM part2;
