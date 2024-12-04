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
all_x_mas AS (
    SELECT a.letter
    FROM
        part1 AS a
    INNER JOIN part1 AS topright
        ON
            topright.letter IN ('M', 'S')
            AND a.coord_x + 1 = topright.coord_x
            AND a.coord_y + 1 = topright.coord_y
    INNER JOIN part1 AS topleft
        ON
            topleft.letter IN ('M', 'S')
            AND a.coord_x - 1 = topleft.coord_x
            AND a.coord_y + 1 = topleft.coord_y
    INNER JOIN part1 AS bottomright
        ON
            bottomright.letter IN ('M', 'S')
            AND a.coord_x + 1 = bottomright.coord_x
            AND a.coord_y - 1 = bottomright.coord_y
    INNER JOIN part1 AS bottomleft
        ON
            bottomleft.letter IN ('M', 'S')
            AND a.coord_x - 1 = bottomleft.coord_x
            AND a.coord_y - 1 = bottomleft.coord_y
    WHERE
        a.letter = 'A'
        AND topleft.letter != bottomright.letter
        AND topright.letter != bottomleft.letter
)

SELECT count(*) AS count_xmas
FROM
    all_x_mas
