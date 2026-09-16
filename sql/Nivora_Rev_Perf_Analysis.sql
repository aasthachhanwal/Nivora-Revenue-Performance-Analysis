DROP TABLE IF EXISTS order_promotions;
DROP TABLE IF EXISTS deliveries;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS promotions;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS dark_stores;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    signup_date DATE NOT NULL,
    acquisition_source VARCHAR(50),
    zone VARCHAR(50)
);

CREATE TABLE dark_stores (
    dark_store_id INTEGER PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    zone VARCHAR(50) NOT NULL,
    launch_date DATE NOT NULL
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category VARCHAR(100) NOT NULL,
    brand VARCHAR(100),
    mrp NUMERIC(10,2) NOT NULL
);

CREATE TABLE promotions (
    promotion_id INTEGER PRIMARY KEY,
    promotion_type VARCHAR(50) NOT NULL,
    discount_value NUMERIC(10,2) NOT NULL
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    dark_store_id INTEGER NOT NULL,
    order_date TIMESTAMP NOT NULL,
    order_value NUMERIC(10,2) NOT NULL,
    order_status VARCHAR(30) NOT NULL,

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT fk_orders_store
        FOREIGN KEY (dark_store_id)
        REFERENCES dark_stores(dark_store_id)
);

CREATE TABLE order_items (
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    selling_price NUMERIC(10,2) NOT NULL,

    PRIMARY KEY (order_id, product_id),

    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

CREATE TABLE deliveries (
    order_id INTEGER PRIMARY KEY,
    promised_delivery_time TIMESTAMP NOT NULL,
    actual_delivery_time TIMESTAMP,
    delay_minutes INTEGER,

    CONSTRAINT fk_deliveries_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

CREATE TABLE order_promotions (
    order_id INTEGER NOT NULL,
    promotion_id INTEGER NOT NULL,

    PRIMARY KEY (order_id, promotion_id),

    CONSTRAINT fk_order_promotions_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT fk_order_promotions_promotion
        FOREIGN KEY (promotion_id)
        REFERENCES promotions(promotion_id)
);

-- ============================================
-- NIVORA DATA GENERATION
-- ============================================

-- 1. CUSTOMERS
INSERT INTO customers (
    customer_id,
    signup_date,
    acquisition_source,
    zone
)
SELECT
    gs AS customer_id,

    DATE '2026-01-01'
        + ((gs * 7) % 60) AS signup_date,

    CASE (gs % 5)
        WHEN 0 THEN 'Google Ads'
        WHEN 1 THEN 'Instagram'
        WHEN 2 THEN 'Referral'
        WHEN 3 THEN 'Organic'
        ELSE 'Influencer'
    END AS acquisition_source,

    CASE (gs % 6)
        WHEN 0 THEN 'South Delhi'
        WHEN 1 THEN 'Gurgaon'
        WHEN 2 THEN 'Noida'
        WHEN 3 THEN 'West Delhi'
        WHEN 4 THEN 'Faridabad'
        ELSE 'East Delhi'
    END AS zone

FROM generate_series(1, 7500) AS gs;


-- 2. DARK STORES
INSERT INTO dark_stores (
    dark_store_id,
    store_name,
    zone,
    launch_date
)
VALUES
(1, 'Nivora Saket', 'South Delhi', DATE '2025-07-01'),
(2, 'Nivora Gurgaon Central', 'Gurgaon', DATE '2025-08-15'),
(3, 'Nivora Noida Sector 18', 'Noida', DATE '2025-09-01'),
(4, 'Nivora Rajouri Garden', 'West Delhi', DATE '2025-10-10'),
(5, 'Nivora Faridabad', 'Faridabad', DATE '2025-11-01'),
(6, 'Nivora East Delhi', 'East Delhi', DATE '2025-11-20'),
(7, 'Nivora Dwarka', 'West Delhi', DATE '2026-01-05'),
(8, 'Nivora Ghaziabad', 'East Delhi', DATE '2026-01-20');


-- 3. PRODUCTS
INSERT INTO products (
    product_id,
    product_name,
    category,
    brand,
    mrp
)
VALUES
(1, 'Full Cream Milk 1L', 'Dairy', 'Amul', 68.00),
(2, 'Curd 400g', 'Dairy', 'Amul', 45.00),
(3, 'Paneer 200g', 'Dairy', 'Amul', 95.00),
(4, 'Cheese Slices 200g', 'Dairy', 'Amul', 145.00),

(5, 'Bananas 1kg', 'Fresh Produce', 'Nivora Select', 55.00),
(6, 'Apples 1kg', 'Fresh Produce', 'Nivora Select', 160.00),
(7, 'Potatoes 1kg', 'Fresh Produce', 'Nivora Select', 42.00),
(8, 'Tomatoes 1kg', 'Fresh Produce', 'Nivora Select', 48.00),

(9, 'Potato Chips 100g', 'Snacks', 'ITC', 40.00),
(10, 'Cookies 200g', 'Snacks', 'Britannia', 70.00),
(11, 'Namkeen 200g', 'Snacks', 'HUL', 65.00),
(12, 'Chocolate Bar 50g', 'Snacks', 'ITC', 50.00),

(13, 'Cola 750ml', 'Beverages', 'Coca Cola', 55.00),
(14, 'Orange Juice 1L', 'Beverages', 'Dabur', 120.00),
(15, 'Cold Coffee 250ml', 'Beverages', 'Amul', 45.00),
(16, 'Mineral Water 1L', 'Beverages', 'Nivora Select', 25.00),

(17, 'Rice 5kg', 'Staples', 'India Gate', 420.00),
(18, 'Wheat Flour 5kg', 'Staples', 'Aashirvaad', 310.00),
(19, 'Toor Dal 1kg', 'Staples', 'Tata', 165.00),
(20, 'Cooking Oil 1L', 'Staples', 'Fortune', 145.00),

(21, 'Dishwash Liquid 500ml', 'Household', 'Vim', 115.00),
(22, 'Laundry Detergent 1kg', 'Household', 'Surf Excel', 190.00),
(23, 'Garbage Bags 30pcs', 'Household', 'Nivora Select', 90.00),
(24, 'Toilet Cleaner 500ml', 'Household', 'Harpic', 105.00),

(25, 'Shampoo 340ml', 'Personal Care', 'Dove', 260.00),
(26, 'Toothpaste 150g', 'Personal Care', 'Colgate', 115.00),
(27, 'Face Wash 100ml', 'Personal Care', 'HUL', 210.00),

(28, 'Ready Poha 250g', 'Ready to Eat', 'MTR', 85.00),
(29, 'Instant Noodles 4 Pack', 'Ready to Eat', 'Nestle', 80.00),
(30, 'Frozen Paratha 400g', 'Ready to Eat', 'McCain', 180.00);


-- 4. PROMOTIONS
INSERT INTO promotions (
    promotion_id,
    promotion_type,
    discount_value
)
VALUES
(1, 'First Order', 100.00),
(2, 'Free Delivery', 40.00),
(3, 'Repeat Customer', 75.00),
(4, 'Weekend Offer', 60.00),
(5, 'Category Offer', 50.00),
(6, 'High Basket Offer', 150.00);


-- ============================================================
-- 5. REGENERATE ORDERS
-- ============================================================

TRUNCATE TABLE
    order_promotions,
    deliveries,
    order_items,
    orders;


WITH customer_store AS (

    SELECT
        c.customer_id,
        c.signup_date,

        CASE
            WHEN c.customer_id % 100 < 25 THEN 1
            WHEN c.customer_id % 100 < 43 THEN 2
            WHEN c.customer_id % 100 < 58 THEN 3
            WHEN c.customer_id % 100 < 70 THEN 4
            WHEN c.customer_id % 100 < 80 THEN 5
            WHEN c.customer_id % 100 < 88 THEN 6
            WHEN c.customer_id % 100 < 95 THEN 7
            ELSE 8
        END AS primary_store

    FROM customers c
),

order_base AS (

    SELECT
        cs.customer_id,
        gs AS order_number,
        cs.primary_store,
        cs.signup_date,

        cs.signup_date
        + (
            ((gs - 1) * 22)
            + ((cs.customer_id * 3 + gs * 5) % 10)
          ) * INTERVAL '1 day' AS order_date

    FROM customer_store cs

    CROSS JOIN LATERAL generate_series(
        1,

        CASE
            WHEN cs.primary_store IN (7, 8)
                THEN 1 + (cs.customer_id % 3)

            WHEN cs.primary_store IN (5, 6)
                THEN 1 + (cs.customer_id % 4)

            ELSE 2 + (cs.customer_id % 4)
        END

    ) AS gs
),

orders_with_store AS (

    SELECT
        ob.customer_id,
        ob.order_number,
        ob.order_date,

        CASE

            WHEN ob.primary_store IN (
                SELECT dark_store_id
                FROM dark_stores
                WHERE launch_date <= ob.order_date::DATE
            )
            AND random() < 0.85

            THEN ob.primary_store

            ELSE (
                SELECT s.dark_store_id
                FROM dark_stores s
                WHERE s.launch_date <= ob.order_date::DATE
                ORDER BY random()
                LIMIT 1
            )

        END AS dark_store_id

    FROM order_base ob
)

INSERT INTO orders (
    order_id,
    customer_id,
    dark_store_id,
    order_date,
    order_value,
    order_status
)

SELECT
    ROW_NUMBER() OVER (
        ORDER BY customer_id, order_number
    )::INTEGER AS order_id,

    customer_id,

    dark_store_id,

    order_date,

    0.00 AS order_value,

    CASE
        WHEN dark_store_id IN (7, 8)
             AND random() < 0.12
            THEN 'Cancelled'

        WHEN dark_store_id = 6
             AND random() < 0.07
            THEN 'Cancelled'

        WHEN random() < 0.03
            THEN 'Cancelled'

        ELSE 'Completed'
    END AS order_status

FROM orders_with_store;


-- ============================================================
-- 6. ORDER ITEMS
-- ============================================================

WITH order_sequence AS (

    SELECT
        o.*,

        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_date, order_id
        ) AS customer_order_number

    FROM orders o
),

item_counts AS (

    SELECT
        os.*,

        1 + (
            os.order_id + os.customer_order_number
        ) % 4 AS number_of_items

    FROM order_sequence os
)

INSERT INTO order_items (
    order_id,
    product_id,
    quantity,
    selling_price
)

SELECT
    ic.order_id,

    CASE
        WHEN ic.customer_order_number = 1 THEN

            1 + (
                ic.order_id * 7 + item_no * 5
            ) % 30

        ELSE

            CASE
                WHEN (
                    ic.order_id * 3 + item_no * 5
                ) % 12 < 8

                THEN

                    1 + (
                        ic.order_id * 3 + item_no * 5
                    ) % 8

                ELSE

                    17 + (
                        ic.order_id * 3 + item_no * 5
                    ) % 4

            END
    END AS product_id,

    1 + (
        ic.order_id + item_no
    ) % 3 AS quantity,

    ROUND(
        p.mrp *
        CASE
            WHEN ic.customer_order_number = 1
                THEN 0.92
            ELSE 0.97
        END,
        2
    ) AS selling_price

FROM item_counts ic

CROSS JOIN LATERAL generate_series(
    1,
    ic.number_of_items
) AS item_no

JOIN products p
    ON p.product_id =
        CASE
            WHEN ic.customer_order_number = 1 THEN

                1 + (
                    ic.order_id * 7 + item_no * 5
                ) % 30

            ELSE

                CASE
                    WHEN (
                        ic.order_id * 3 + item_no * 5
                    ) % 12 < 8

                    THEN

                        1 + (
                            ic.order_id * 3 + item_no * 5
                        ) % 8

                    ELSE

                        17 + (
                            ic.order_id * 3 + item_no * 5
                        ) % 4

                END
        END

WHERE ic.order_status = 'Completed';


-- ============================================================
-- 7. CALCULATE ORDER VALUE
-- ============================================================

UPDATE orders o

SET order_value = x.order_value

FROM (

    SELECT
        order_id,

        ROUND(
            SUM(quantity * selling_price),
            2
        ) AS order_value

    FROM order_items

    GROUP BY order_id

) x

WHERE o.order_id = x.order_id;


-- ============================================================
-- 8. DELIVERIES
-- ============================================================

INSERT INTO deliveries (
    order_id,
    promised_delivery_time,
    actual_delivery_time,
    delay_minutes
)

SELECT
    o.order_id,

    o.order_date
        + INTERVAL '35 minutes',

    o.order_date
        + INTERVAL '35 minutes'
        + d.delay_minutes * INTERVAL '1 minute',

    d.delay_minutes

FROM orders o

CROSS JOIN LATERAL (

    SELECT
        CASE
            WHEN o.dark_store_id IN (7, 8)
                THEN 15 + floor(random() * 35)::INTEGER

            WHEN o.dark_store_id = 6
                THEN 8 + floor(random() * 25)::INTEGER

            ELSE
                floor(random() * 16)::INTEGER
        END AS delay_minutes

) d

WHERE o.order_status = 'Completed';


-- ============================================================
-- 9. APPLY PROMOTIONS
-- ============================================================

WITH order_sequence AS (

    SELECT
        o.*,

        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_date, order_id
        ) AS customer_order_number

    FROM orders o

    WHERE order_status = 'Completed'
)

INSERT INTO order_promotions (
    order_id,
    promotion_id
)

SELECT
    order_id,

    CASE
        WHEN customer_order_number = 1
            THEN 1

        WHEN order_value >= 800
            THEN 6

        WHEN EXTRACT(
            DOW FROM order_date
        ) IN (0, 6)
            THEN 4

        ELSE 3
    END AS promotion_id

FROM order_sequence

WHERE random() <
    CASE
        WHEN customer_order_number = 1
            THEN 0.70

        ELSE 0.45
    END;
SELECT
    'customers' AS table_name,
    COUNT(*) AS row_count
FROM customers

UNION ALL

SELECT
    'dark_stores',
    COUNT(*)
FROM dark_stores

UNION ALL

SELECT
    'products',
    COUNT(*)
FROM products

UNION ALL

SELECT
    'promotions',
    COUNT(*)
FROM promotions

UNION ALL

SELECT
    'orders',
    COUNT(*)
FROM orders

UNION ALL

SELECT
    'order_items',
    COUNT(*)
FROM order_items

UNION ALL

SELECT
    'deliveries',
    COUNT(*)
FROM deliveries

UNION ALL

SELECT
    'order_promotions',
    COUNT(*)
FROM order_promotions;
SELECT
    order_status,
    COUNT(*) AS orders,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM orders
GROUP BY order_status
ORDER BY orders DESC;
SELECT
    COUNT(*) AS invalid_customer_links
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
SELECT
    COUNT(*) AS mismatched_orders
FROM orders o
JOIN (
    SELECT
        order_id,
        ROUND(SUM(quantity * selling_price), 2) AS calculated_value
    FROM order_items
    GROUP BY order_id
) oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
  AND o.order_value <> oi.calculated_value;
  SELECT
    CASE
        WHEN delay_minutes = 0 THEN 'On Time'
        WHEN delay_minutes <= 10 THEN '1-10 min late'
        WHEN delay_minutes <= 20 THEN '11-20 min late'
        ELSE '20+ min late'
    END AS delivery_bucket,
    COUNT(*) AS orders
FROM deliveries
GROUP BY
    CASE
        WHEN delay_minutes = 0 THEN 'On Time'
        WHEN delay_minutes <= 10 THEN '1-10 min late'
        WHEN delay_minutes <= 20 THEN '11-20 min late'
        ELSE '20+ min late'
    END
ORDER BY orders DESC;
SELECT
    COUNT(*) AS orders_before_store_launch
FROM orders o
JOIN dark_stores s
    ON o.dark_store_id = s.dark_store_id
WHERE o.order_date::DATE < s.launch_date;
SELECT
    dark_store_id,
    store_name,
    zone,
    launch_date
FROM dark_stores
ORDER BY launch_date;
WITH order_value_check AS (

    SELECT
        o.order_id,
        o.order_value,
        ROUND(
            SUM(oi.quantity * oi.selling_price),
            2
        ) AS calculated_value

    FROM orders o

    JOIN order_items oi
        ON o.order_id = oi.order_id

    WHERE o.order_status = 'Completed'

    GROUP BY
        o.order_id,
        o.order_value
)

SELECT
    (
        SELECT COUNT(*)
        FROM orders o
        LEFT JOIN customers c
            ON o.customer_id = c.customer_id
        WHERE c.customer_id IS NULL
    ) AS invalid_customer_links,

    (
        SELECT COUNT(*)
        FROM orders o
        LEFT JOIN dark_stores s
            ON o.dark_store_id = s.dark_store_id
        WHERE s.dark_store_id IS NULL
    ) AS invalid_store_links,

    (
        SELECT COUNT(*)
        FROM order_value_check
        WHERE order_value <> calculated_value
    ) AS mismatched_order_values,

    (
        SELECT COUNT(*)
        FROM orders o
        JOIN dark_stores s
            ON o.dark_store_id = s.dark_store_id
        WHERE o.order_date::DATE < s.launch_date
    ) AS orders_before_store_launch,

    (
        SELECT COUNT(*)
        FROM orders o
        LEFT JOIN deliveries d
            ON o.order_id = d.order_id
        WHERE o.order_status = 'Completed'
          AND d.order_id IS NULL
    ) AS completed_orders_without_delivery;
	
WITH monthly_revenue AS ( 
    SELECT DATE_TRUNC('month', order_date)::DATE AS month, COUNT(*) AS orders, ROUND(SUM(order_value), 2) AS revenue, ROUND(SUM(order_value) / COUNT(*), 2) AS aov 
    FROM orders 
    WHERE order_status = 'Completed' 
    GROUP BY DATE_TRUNC('month', order_date)) 
 
SELECT month AS "Month", orders AS "Orders", revenue AS "Revenue", aov AS "Average Order Value", ROUND((revenue - LAG(revenue) OVER (ORDER BY month)) / NULLIF(LAG(revenue) OVER (ORDER BY month), 0) * 100, 2) AS "MoM Revenue Growth Percent" 
FROM monthly_revenue 
ORDER BY month;
SELECT s.store_name AS "Store", s.zone AS "Zone", COUNT(o.order_id) AS "Orders", ROUND(COALESCE(SUM(CASE WHEN o.order_status = 'Completed' THEN o.order_value ELSE 0 END), 0), 2) AS "Revenue", ROUND(COALESCE(AVG(CASE WHEN o.order_status = 'Completed' THEN o.order_value END), 0), 2) AS "Average Order Value", ROUND(100.0 * COUNT(CASE WHEN o.order_status = 'Cancelled' THEN 1 END) / NULLIF(COUNT(o.order_id), 0), 2) AS "Cancellation Rate Percent", ROUND(COALESCE(AVG(d.delay_minutes), 0), 2) AS "Average Delay Minutes"
FROM dark_stores s
LEFT JOIN orders o ON s.dark_store_id = o.dark_store_id
LEFT JOIN deliveries d ON o.order_id = d.order_id
GROUP BY s.store_name, s.zone
ORDER BY "Revenue" DESC;
SELECT p.category AS "Category", COUNT(DISTINCT oi.order_id) AS "Orders", SUM(oi.quantity) AS "Units Sold", ROUND(SUM(oi.quantity * oi.selling_price), 2) AS "Revenue", ROUND(SUM(oi.quantity * oi.selling_price) / NULLIF(COUNT(DISTINCT oi.order_id), 0), 2) AS "Revenue per Order"
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY p.category
ORDER BY "Revenue" DESC;
SELECT s.store_name AS "Store", s.zone AS "Zone", COUNT(d.order_id) AS "Delivered Orders", ROUND(AVG(d.delay_minutes), 2) AS "Average Delay Minutes", ROUND(100.0 * COUNT(CASE WHEN d.delay_minutes > 10 THEN 1 END) / NULLIF(COUNT(d.order_id), 0), 2) AS "Orders Over 10 Min Late Percent", MAX(d.delay_minutes) AS "Maximum Delay Minutes"
FROM dark_stores s
JOIN orders o ON s.dark_store_id = o.dark_store_id
JOIN deliveries d ON o.order_id = d.order_id
WHERE o.order_status = 'Completed'
GROUP BY s.store_name, s.zone
ORDER BY "Average Delay Minutes" DESC;
WITH customer_cohorts AS (
    SELECT customer_id, DATE_TRUNC('month', signup_date)::DATE AS cohort_month
    FROM customers),
customer_activity AS (SELECT DISTINCT customer_id, DATE_TRUNC('month', order_date)::DATE AS order_month
    FROM orders
    WHERE order_status = 'Completed'),
cohort_activity AS (SELECT cc.cohort_month, ca.order_month, COUNT(DISTINCT ca.customer_id) AS "Retained Customers", (EXTRACT(YEAR FROM ca.order_month) - EXTRACT(YEAR FROM cc.cohort_month)) * 12 + EXTRACT(MONTH FROM ca.order_month) - EXTRACT(MONTH FROM cc.cohort_month) AS "Months Since Signup"
    FROM customer_cohorts cc
    JOIN customer_activity ca ON cc.customer_id = ca.customer_id
    GROUP BY cc.cohort_month, ca.order_month),
cohort_size AS (
    SELECT cohort_month, COUNT(*) AS "Cohort Size"
    FROM customer_cohorts
    GROUP BY cohort_month)
SELECT ca.cohort_month AS "Cohort Month", ca."Months Since Signup", ca."Retained Customers", cs."Cohort Size", ROUND(100.0 * ca."Retained Customers" / NULLIF(cs."Cohort Size", 0), 2) AS "Retention Percent"
FROM cohort_activity ca
JOIN cohort_size cs ON ca.cohort_month = cs.cohort_month
WHERE ca."Months Since Signup" >= 0
ORDER BY ca.cohort_month, ca."Months Since Signup";
WITH customer_orders AS (
    SELECT o.order_id, o.customer_id, o.order_value, o.order_date, op.promotion_id, p.promotion_type, ROW_NUMBER() OVER (PARTITION BY o.customer_id ORDER BY o.order_date, o.order_id) AS "Customer Order Number"
    FROM orders o
    JOIN order_promotions op ON o.order_id = op.order_id
    JOIN promotions p ON op.promotion_id = p.promotion_id
    WHERE o.order_status = 'Completed')
SELECT promotion_type AS "Promotion Type", COUNT(*) AS "Promoted Orders", COUNT(DISTINCT customer_id) AS "Customers", ROUND(SUM(order_value), 2) AS "Revenue", ROUND(AVG(order_value), 2) AS "Average Order Value", ROUND(100.0 * COUNT(CASE WHEN "Customer Order Number" = 1 THEN 1 END) / NULLIF(COUNT(*), 0), 2) AS "First Order Share Percent"
FROM customer_orders
GROUP BY promotion_type
ORDER BY "Revenue" DESC;
