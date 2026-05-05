-- RAW DATA --

-- The raw dataset includes incomplete and inconsistent records, which may inflate or distort aggregated metrics.
--The transformed dataset provides more accurate results by removing such records during the data cleaning process.


-- Revenue by category (before cleaning)
SELECT 
    t.product_category_name_english AS Product_Category,
    SUM(ot.price + ot.freight_value) AS Revenue
FROM orders o
LEFT JOIN order_items ot ON o.order_id = ot.order_id
LEFT JOIN products p ON ot.product_id = p.product_id
LEFT JOIN translation t ON p.product_category_name = t.product_category_name
GROUP BY t.product_category_name_english
ORDER BY Revenue DESC


-- Revenue by state (before cleaning)
SELECT 
    s.seller_state,
    s.seller_city,
    ROUND(SUM(ot.price + ot.freight_value),2) AS Revenue 
FROM orders o
LEFT JOIN order_items ot ON o.order_id = ot.order_id 
LEFT JOIN sellers s ON ot.seller_id = s.seller_id
GROUP BY s.seller_state, s.seller_city
ORDER BY Revenue DESC


-- Delivery time by Location (before cleaning)
SELECT 
    CASE 
        WHEN s.seller_state = c.customer_state THEN 'Same State'
        ELSE 'Different State'
    END AS same_state,
    AVG(DATEDIFF(DAY, o.order_delivered_carrier_date, o.order_delivered_customer_date)) AS Avg_delivery_time
FROM orders o
LEFT JOIN order_items ot ON o.order_id = ot.order_id
LEFT JOIN sellers s ON ot.seller_id = s.seller_id
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL AND o.order_delivered_carrier_date IS NOT NULL
GROUP BY 
    CASE 
        WHEN s.seller_state = c.customer_state THEN 'Same State'
        ELSE 'Different State'
    END


-- Delays by Location (before cleaning)
SELECT 
    CASE 
        WHEN s.seller_state = c.customer_state THEN 'Same State'
        ELSE 'Different State'
    END AS same_state,
    AVG(CASE 
            WHEN DATEDIFF(SECOND, o.order_estimated_delivery_date, o.order_delivered_customer_date) <= 0 
            THEN 0
            ELSE DATEDIFF(SECOND, o.order_estimated_delivery_date, o.order_delivered_customer_date) / 86400.0
        END) AS Avg_delay
FROM orders o
LEFT JOIN order_items ot ON o.order_id = ot.order_id
LEFT JOIN sellers s ON ot.seller_id = s.seller_id
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE 
    o.order_delivered_customer_date IS NOT NULL AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY 
    CASE 
        WHEN s.seller_state = c.customer_state THEN 'Same State'
        ELSE 'Different State'
    END



-- TRANSFORMED DATA --


-- Revenue by category
-- Top categories: health_beauty, watches_gifts, bed_bath_table
SELECT 
    category AS [Product Category], 
    ROUND(SUM(total_order_value),2) AS Revenue
FROM transOrders
GROUP BY category
ORDER BY Revenue DESC


-- Revenue by state (city)
-- Top sales concentrated in São Paulo (SP), especially São Paulo city and surrounding areas
SELECT 
    seller_state AS [Seller State],
    seller_city AS [Seller City],
    ROUND(SUM(total_order_value),2) AS Revenue
FROM transOrders
GROUP BY seller_state, seller_city
ORDER BY Revenue DESC


-- Delivery time by Location
-- Same-state deliveries are significantly faster (~4 days vs ~11 days)
SELECT 
    same_state,
    AVG(delivery_time) AS [Average Delivery Time]
FROM transOrders
GROUP BY same_state


-- Delays by Location
-- Cross-state deliveries have higher delays (~0.89 vs ~0.34 days)
SELECT 
    same_state,
    AVG(delivery_delay_days) AS [Average Delay Time]
FROM transOrders
GROUP BY same_state


