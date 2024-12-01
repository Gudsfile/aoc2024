WITH parsed_lists AS (
    SELECT
        split_part(lists, '   ', 1)::INTEGER AS l1_id,
        split_part(lists, '   ', 2)::INTEGER AS l2_id
    FROM
        read_csv(
            'datasets/day01.txt', header = false, columns = { 'lists': 'TEXT' }
        )
),

ranked_list1 AS (
    SELECT
        l1_id AS id,
        row_number() OVER (ORDER BY l1_id) AS rank
    FROM parsed_lists
),

ranked_list2 AS (
    SELECT
        l2_id AS id,
        row_number() OVER (ORDER BY l2_id) AS rank
    FROM parsed_lists
)

SELECT sum(abs(ranked_list1.id - ranked_list2.id)) AS distance
FROM ranked_list1
INNER JOIN ranked_list2 USING (rank);
