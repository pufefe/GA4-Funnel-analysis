SELECT
    event_name,
    COUNT(DISTINCT user_pseudo_id) AS users
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
    AND event_name IN ('view_item', 'add_to_cart', 'begin_checkout', 'add_shipping_info', 'add_payment_info')
GROUP BY event_name
ORDER BY
    CASE event_name
        WHEN 'view_item'         THEN 1
        WHEN 'add_to_cart'       THEN 2
        WHEN 'begin_checkout'    THEN 3
        WHEN 'add_shipping_info' THEN 4
        WHEN 'add_payment_info'  THEN 5
    END;