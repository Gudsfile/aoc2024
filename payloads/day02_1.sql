WITH parsed_reports AS (
    SELECT
        row_number() OVER () AS report_id,
        split(lists, ' ') AS report
    FROM
        read_csv(
            'datasets/day02.txt',
            header = false,
            columns = { 'lists': 'TEXT' }
        )
),

levels AS (
    SELECT
        report_id,
        unnest(report)::INTEGER AS level,
        generate_subscripts(report, 1) AS level_id
    FROM parsed_reports
),

level_differences AS (
    SELECT
        l1.report_id,
        l1.level_id,
        l1.level - l2.level AS difference
    FROM levels AS l1
    LEFT JOIN
        levels AS l2
        ON l1.report_id = l2.report_id AND l1.level_id = l2.level_id + 1
),

difference_control AS (
    SELECT
        report_id,
        level_id,
        (difference BETWEEN -3 AND 3 AND difference != 0) AS is_diff_safe,
        difference > 0 AS is_positive
    FROM level_differences
),

reports AS (
    SELECT
        report_id,
        max(level_id) - 1 AS count_levels,
        sum(CASE WHEN is_diff_safe THEN 1 ELSE 0 END) AS count_diff_safe,
        sum(CASE WHEN is_positive THEN 1 ELSE 0 END) AS count_positive,
        (count_diff_safe = count_levels) AND (count_positive = count_levels OR count_positive = 0) AS is_safe
    FROM difference_control
    GROUP BY report_id
    ORDER BY report_id
)

SELECT count(*) AS count_safe_reports FROM reports WHERE is_safe;
