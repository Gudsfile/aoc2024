CREATE
OR REPLACE TABLE part0 AS (
    SELECT
        row_of_letters,
        row_number() OVER () AS coord_x
    FROM
        (
            SELECT regexp_split_to_table(content, '\n') AS row_of_letters
            FROM
                read_text('datasets/day04.txt')
        )
);

CREATE
OR REPLACE TABLE part1 AS (
    SELECT
        coord_x,
        row_number() OVER (
            PARTITION BY
                coord_x
        ) AS coord_y,
        letter
    FROM
        (
            SELECT
                coord_x,
                unnest(regexp_split_to_array(row_of_letters, '')) AS letter
            FROM
                part0
        )
);

WITH
sens1 AS (
    SELECT * -- noqa: RF02
    FROM
        part1 AS x
    INNER JOIN part1 AS m
        ON
            m.letter = 'M'
            AND x.coord_x = m.coord_x - 1
            AND x.coord_y = m.coord_y
    INNER JOIN part1 AS a
        ON
            a.letter = 'A'
            AND x.coord_x = a.coord_x - 2
            AND x.coord_y = a.coord_y
    INNER JOIN part1 AS s
        ON
            s.letter = 'S'
            AND x.coord_x = s.coord_x - 3
            AND x.coord_y = s.coord_y
    WHERE
        x.letter = 'X'
),

sens2 AS (
    SELECT * -- noqa: RF02
    FROM
        part1 AS x
    INNER JOIN part1 AS m
        ON
            m.letter = 'M'
            AND x.coord_x = m.coord_x + 1
            AND x.coord_y = m.coord_y
    INNER JOIN part1 AS a
        ON
            a.letter = 'A'
            AND x.coord_x = a.coord_x + 2
            AND x.coord_y = a.coord_y
    INNER JOIN part1 AS s
        ON
            s.letter = 'S'
            AND x.coord_x = s.coord_x + 3
            AND x.coord_y = s.coord_y
    WHERE
        x.letter = 'X'
),

sens3 AS (
    SELECT * -- noqa: RF02
    FROM
        part1 AS x
    INNER JOIN part1 AS m
        ON
            m.letter = 'M'
            AND x.coord_x = m.coord_x
            AND x.coord_y = m.coord_y - 1
    INNER JOIN part1 AS a
        ON
            a.letter = 'A'
            AND x.coord_x = a.coord_x
            AND x.coord_y = a.coord_y - 2
    INNER JOIN part1 AS s
        ON
            s.letter = 'S'
            AND x.coord_x = s.coord_x
            AND x.coord_y = s.coord_y - 3
    WHERE
        x.letter = 'X'
),

sens4 AS (
    SELECT * -- noqa: RF02
    FROM
        part1 AS x
    INNER JOIN part1 AS m
        ON
            m.letter = 'M'
            AND x.coord_x = m.coord_x
            AND x.coord_y = m.coord_y + 1
    INNER JOIN part1 AS a
        ON
            a.letter = 'A'
            AND x.coord_x = a.coord_x
            AND x.coord_y = a.coord_y + 2
    INNER JOIN part1 AS s
        ON
            s.letter = 'S'
            AND x.coord_x = s.coord_x
            AND x.coord_y = s.coord_y + 3
    WHERE
        x.letter = 'X'
),

sens5 AS (
    SELECT * -- noqa: RF02
    FROM
        part1 AS x
    INNER JOIN part1 AS m
        ON
            m.letter = 'M'
            AND x.coord_x = m.coord_x + 1
            AND x.coord_y = m.coord_y + 1
    INNER JOIN part1 AS a
        ON
            a.letter = 'A'
            AND x.coord_x = a.coord_x + 2
            AND x.coord_y = a.coord_y + 2
    INNER JOIN part1 AS s
        ON
            s.letter = 'S'
            AND x.coord_x = s.coord_x + 3
            AND x.coord_y = s.coord_y + 3
    WHERE
        x.letter = 'X'
),

sens6 AS (
    SELECT * -- noqa: RF02
    FROM
        part1 AS x
    INNER JOIN part1 AS m
        ON
            m.letter = 'M'
            AND x.coord_x = m.coord_x - 1
            AND x.coord_y = m.coord_y - 1
    INNER JOIN part1 AS a
        ON
            a.letter = 'A'
            AND x.coord_x = a.coord_x - 2
            AND x.coord_y = a.coord_y - 2
    INNER JOIN part1 AS s
        ON
            s.letter = 'S'
            AND x.coord_x = s.coord_x - 3
            AND x.coord_y = s.coord_y - 3
    WHERE
        x.letter = 'X'
),

sens7 AS (
    SELECT * -- noqa: RF02
    FROM
        part1 AS x
    INNER JOIN part1 AS m
        ON
            m.letter = 'M'
            AND x.coord_x = m.coord_x + 1
            AND x.coord_y = m.coord_y - 1
    INNER JOIN part1 AS a
        ON
            a.letter = 'A'
            AND x.coord_x = a.coord_x + 2
            AND x.coord_y = a.coord_y - 2
    INNER JOIN part1 AS s
        ON
            s.letter = 'S'
            AND x.coord_x = s.coord_x + 3
            AND x.coord_y = s.coord_y - 3
    WHERE
        x.letter = 'X'
),

sens8 AS (
    SELECT * -- noqa: RF02
    FROM
        part1 AS x
    INNER JOIN part1 AS m
        ON
            m.letter = 'M'
            AND x.coord_x = m.coord_x - 1
            AND x.coord_y = m.coord_y + 1
    INNER JOIN part1 AS a
        ON
            a.letter = 'A'
            AND x.coord_x = a.coord_x - 2
            AND x.coord_y = a.coord_y + 2
    INNER JOIN part1 AS s
        ON
            s.letter = 'S'
            AND x.coord_x = s.coord_x - 3
            AND x.coord_y = s.coord_y + 3
    WHERE
        x.letter = 'X'
),

all_xmas AS (
    SELECT *
    FROM
        sens1
    UNION
    SELECT *
    FROM
        sens2
    UNION
    SELECT *
    FROM
        sens3
    UNION
    SELECT *
    FROM
        sens4
    UNION
    SELECT *
    FROM
        sens5
    UNION
    SELECT *
    FROM
        sens6
    UNION
    SELECT *
    FROM
        sens7
    UNION
    SELECT *
    FROM
        sens8
)

SELECT count(*) AS count_xmas
FROM
    all_xmas
