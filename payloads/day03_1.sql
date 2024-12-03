CREATE OR REPLACE TABLE part1 AS (
    SELECT unnest(regexp_extract_all(content, '(mul\(\d+,\d+\))')) AS mul
    FROM read_text('datasets/day03.txt')
);

CREATE OR REPLACE TABLE part2 AS (
    SELECT regexp_extract(mul, '(\d+),(\d+)', ['x', 'y']) AS digits
    FROM part1
);

SELECT sum(digits.x::INTEGER * digits.y::INTEGER) AS result -- noqa: RF01
FROM part2;
