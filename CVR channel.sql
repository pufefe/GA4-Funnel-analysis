WITH user_channel AS (
    SELECT
        user_pseudo_id,
        MAX(traffic_source.medium) AS channel
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
    GROUP BY user_pseudo_id
),
funnel AS (
    SELECT
        user_pseudo_id,
        MAX(IF(event_name = 'view_item', 1, 0))        AS viewed,
        MAX(IF(event_name = 'add_payment_info', 1, 0)) AS paid
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
        AND event_name IN ('view_item', 'add_payment_info')
    GROUP BY user_pseudo_id
)
SELECT
    c.channel,
    COUNT(DISTINCT IF(f.viewed = 1, f.user_pseudo_id, NULL)) AS viewers,
    COUNT(DISTINCT IF(f.paid = 1, f.user_pseudo_id, NULL))   AS payers,
    ROUND(
        COUNT(DISTINCT IF(f.paid = 1, f.user_pseudo_id, NULL)) /
        COUNT(DISTINCT IF(f.viewed = 1, f.user_pseudo_id, NULL)) * 100, 1
    ) AS conversion_pct
FROM funnel f
JOIN user_channel c ON f.user_pseudo_id = c.user_pseudo_id
WHERE f.viewed = 1
GROUP BY c.channel
ORDER BY viewers DESC;