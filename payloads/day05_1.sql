CREATE OR REPLACE TABLE parsed_input AS (
    SELECT regexp_split_to_table(content, '\n') AS input_row
    FROM read_text('datasets/day05.txt')
);

CREATE OR REPLACE TABLE rules AS (
    SELECT
        row_number() OVER () AS id,
        input_row[0:2]::integer AS first_page,
        input_row[4:5]::integer AS second_page
    FROM parsed_input
    WHERE regexp_matches(input_row, '\d{2}\|\d{2}$')
);

CREATE OR REPLACE TABLE updates AS (
    SELECT
        row_number() OVER () AS id,
        input_row AS page_numbers,
        input_row[(len(input_row) / 2)::int:(len(input_row) / 2)::int + 1]::int AS middle_page_number
    FROM parsed_input
    WHERE regexp_matches(input_row, '(\d{2},)+\d{2}$')
);

CREATE OR REPLACE TABLE pages AS (
    SELECT
        updates.id AS update_id,
        regexp_split_to_table(updates.page_numbers, ',') AS id
    FROM updates
);

WITH uncorrectly_ordered_updates AS (
    SELECT DISTINCT updates.id
    FROM updates
    INNER JOIN pages ON updates.id = pages.update_id
    INNER JOIN rules ON pages.id = rules.first_page
    WHERE regexp_matches(updates.page_numbers, '.*' || rules.second_page || '.*' || rules.first_page || '.*')
),

middle_page_of_correctly_ordered_updates AS (
    SELECT
        updates.id,
        updates.middle_page_number
    FROM updates
    WHERE
        updates.id NOT IN (SELECT uncorrectly_ordered_updates.id FROM uncorrectly_ordered_updates)
)

SELECT sum(middle_page_number) AS sum_of_middle_page_number_of_correctly_ordrered_updates
FROM middle_page_of_correctly_ordered_updates;
