-- Handling Mixed Date Formats
ALTER TABLE ops_analysis.orders
ADD COLUMN order_date_clean DATE;

UPDATE ops_analysis.orders
SET order_date_clean =
CASE
    WHEN order_date LIKE '%/%'
    THEN TO_DATE(order_date, 'MM/DD/YYYY')
    WHEN order_date LIKE '%-%'
    THEN TO_DATE(order_date, 'DD-MM-YYYY')
END;


-- Creating Shipping Days (Fulfillment Time)
ALTER TABLE ops_analysis.orders
ADD COLUMN shipping_days INT;

UPDATE ops_analysis.orders
SET shipping_days = ship_date - order_date;


-- Delivery Status Classification
ALTER TABLE ops_analysis.orders
ADD COLUMN delivery_status TEXT;

UPDATE ops_analysis.orders
SET delivery_status =
CASE
    WHEN shipping_days <= 4 THEN 'On-Time'
    ELSE 'Late Delivery'
END;


-- Profit Margin Calculation
ALTER TABLE ops_analysis.orders
ADD COLUMN profit_margin NUMERIC;

UPDATE ops_analysis.orders
SET profit_margin =
CASE
    WHEN sales = 0 THEN 0
    ELSE profit / sales
END;


-- Removing Fulfillment Outliers
DELETE FROM ops_analysis.orders
WHERE shipping_days > 30;


