WITH parsed_lists AS (
    SELECT
        split_part(lists, '   ', 1)::INTEGER AS l1_id,
        split_part(lists, '   ', 2)::INTEGER AS l2_id
    FROM
        read_csv(
            'datasets/day01.txt', header = false, columns = { 'lists': 'TEXT' }
        )
),

hits_list2 AS (
    SELECT
        l2_id AS id,
        count(l2_id) AS hits
    FROM parsed_lists
    GROUP BY l2_id
)

SELECT sum(parsed_lists.l1_id * coalesce(hits_list2.hits, 0)) AS similarity
FROM parsed_lists
INNER JOIN hits_list2 ON parsed_lists.l1_id = hits_list2.id;
