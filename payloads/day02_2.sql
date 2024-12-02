CREATE OR REPLACE MACRO type_report_levels(report) AS list_transform(report, x -> x::integer);

WITH parsed_reports AS (
    SELECT
        row_number() OVER () AS report_id,
        type_report_levels(split(lists, ' ')) AS report,
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
),

safe_reports AS (
    SELECT report_id FROM difference_control WHERE is_safe = true
),

unsafe_reports AS (
    SELECT
        report_id,
        report,
        unnest(report) AS level,
        generate_subscripts(report, 1) AS level_id
    FROM parsed_reports
    WHERE report_id NOT IN (SELECT report_id FROM safe_reports) -- noqa: RF02
),

reduced_unsafe_reports AS (
    SELECT
        report_id,
        report[0:level_id - 1] AS head,
        report[level_id + 1:-1] AS foot,
        list_concat(head, foot) AS reduced_report
    FROM unsafe_reports
),

difference_control_for_reduced_reports AS (
    SELECT
        report_id,
        len(reduced_report) AS count_levels,
        list_transform(
            reduced_report,
            (x, i) -> x > reduced_report[i + 1] AND x BETWEEN reduced_report[i + 1] + 1 AND reduced_report[i + 1] + 3
        ) AS is_decreasing,
        list_transform(
            reduced_report,
            (x, i) -> x < reduced_report[i + 1] AND x BETWEEN reduced_report[i + 1] - 3 AND reduced_report[i + 1] - 1
        ) AS is_increasing,
        list_aggregate(list_transform(is_decreasing, x -> CASE WHEN x THEN 1 ELSE 0 END), 'sum') AS d_safe_score,
        list_aggregate(list_transform(is_increasing, x -> CASE WHEN x THEN 1 ELSE 0 END), 'sum') AS i_safe_score,
        (d_safe_score + 1 = count_levels) OR (i_safe_score + 1 = count_levels) AS is_safe
    FROM reduced_unsafe_reports
),

safe_reduced_reports AS (
    SELECT report_id FROM difference_control_for_reduced_reports WHERE is_safe = true
),

all_safe_reports AS (
    SELECT * FROM safe_reports
    UNION
    SELECT * FROM safe_reduced_reports
)

SELECT count(*) AS count_tolerated_reports FROM all_safe_reports;
