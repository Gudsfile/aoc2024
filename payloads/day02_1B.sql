WITH parsed_reports AS (
    SELECT
        row_number() OVER () AS report_id,
        list_transform(split(lists, ' '), x -> x::INTEGER) AS report,
        len(report) AS count_levels
    FROM
        read_csv(
            'datasets/day02.txt',
            header = false,
            columns = { 'lists': 'TEXT' }
        )
),

difference_control AS (
    SELECT
        report_id,
        list_transform(report, (x, i) -> x > report[i + 1] AND x BETWEEN report[i + 1] + 1 AND report[i + 1] + 3)
            AS is_decreasing,
        list_transform(report, (x, i) -> x < report[i + 1] AND x BETWEEN report[i + 1] - 3 AND report[i + 1] - 1)
            AS is_increasing,
        list_aggregate(list_transform(is_decreasing, x -> CASE WHEN x THEN 1 ELSE 0 END), 'sum') AS d_safe_score,
        list_aggregate(list_transform(is_increasing, x -> CASE WHEN x THEN 1 ELSE 0 END), 'sum') AS i_safe_score,
        (d_safe_score + 1 = count_levels) OR (i_safe_score + 1 = count_levels) AS is_safe
    FROM parsed_reports
)

SELECT count(*) AS count_safe_reports FROM difference_control WHERE is_safe;
