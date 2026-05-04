use Supplychain_Project
go

select top (10)*
from dbo.inventory_5x;

select top (10)*
from dbo.production_orders_5x;


SELECT 
    i.prod_id,
    i.prod_name,
    i.on_hand_qty,
    p.production_order_id,
    p.ord_qty
FROM dbo.inventory_5x i
INNER JOIN dbo.production_orders_5x p
    ON i.prod_id = p.product_id;


	SELECT prod_id, prod_name, on_hand_qty, category
FROM dbo.inventory_5x
WHERE on_hand_qty < 100;

-- finding category of brake system and steering system 
SELECT prod_id, prod_name, category, on_hand_qty
FROM dbo.inventory_5x
WHERE category = 'brake system'
   OR category = 'steering system';

   Select distinct category 
   FROM dbo.inventory_5x;

  -- focusing on all divisions except Hydraulics 
   SELECT prod_id, prod_name, category, on_hand_qty
FROM dbo.inventory_5x
WHERE NOT category = 'hydraulics'; 


-- focusing on all production orders which is not complete 

SELECT production_order_id, product_id, job_id, job_name, ord_qty, status
FROM dbo.production_orders_5x
WHERE status <> 'Completed';

-- finding the total no of orders and Quantity currently in production 
SELECT 
    status,
    COUNT(production_order_id) AS total_orders,
    SUM(ord_qty) AS total_order_qty
FROM dbo.production_orders_5x
WHERE status <> 'Completed'
GROUP BY status;

-- finding top 10 products with highest inventory 
SELECT TOP (10) prod_id, prod_name, on_hand_qty, category
FROM dbo.inventory_5x

-- finding products with lowest inventory value 

SELECT prod_id, prod_name, on_hand_qty, unit_price,
       on_hand_qty * unit_price AS inventory_value
FROM dbo.inventory_5x
ORDER BY on_hand_qty * unit_price ASC;

-- sorting by category and stock using multi column sorting
SELECT prod_id, prod_name, category, on_hand_qty
FROM dbo.inventory_5x
ORDER BY category ASC, on_hand_qty DESC;

--using sum to measure total stock by category 

SELECT SUM(on_hand_qty) AS total_inventory_qty , category
FROM dbo.inventory_5x
group by category;

-- categories with higher stock  volume 
SELECT category,
       SUM(on_hand_qty) AS total_stock
FROM dbo.inventory_5x
GROUP BY category
HAVING SUM(on_hand_qty) > 500;

-- checking whether current inventory can support production demans 

SELECT i.prod_id,
       i.prod_name,
       SUM(i.on_hand_qty) AS inventory_qty,
       SUM(p.ord_qty) AS total_demand
FROM dbo.inventory_5x i
INNER JOIN dbo.production_orders_5x p
    ON i.prod_id = p.product_id
GROUP BY i.prod_id, i.prod_name;

-- detecting shortages while demand exceeds inventory 
SELECT i.prod_id,
       i.prod_name,
       SUM(i.on_hand_qty) AS inventory_qty,
       SUM(p.ord_qty) AS total_demand,
       SUM(p.ord_qty) - SUM(i.on_hand_qty) AS shortage_qty
FROM dbo.inventory_5x i
INNER JOIN dbo.production_orders_5x p
    ON i.prod_id = p.product_id
GROUP BY i.prod_id, i.prod_name
HAVING SUM(p.ord_qty) > SUM(i.on_hand_qty);

-- finding products with inventory but no production demand
SELECT i.prod_id,
       i.prod_name,
       i.on_hand_qty,
       i.category
FROM dbo.inventory_5x i
LEFT JOIN dbo.production_orders_5x p
    ON i.prod_id = p.product_id
WHERE p.product_id IS NULL;

-- 1. Total price for each job
SELECT 
    p.job_name,
    SUM(i.unit_price * p.ord_qty) AS total_price_per_job
FROM dbo.production_orders_5x p
JOIN dbo.inventory_5x i
    ON p.product_id = i.prod_id
GROUP BY p.job_name;

-- 2. Total price per category for each job
SELECT 
    p.job_name,
    i.category,
    SUM(i.unit_price * p.ord_qty) AS total_price
FROM dbo.production_orders_5x p
JOIN dbo.inventory_5x i
    ON p.product_id = i.prod_id
GROUP BY p.job_name, i.category;

-- 3. Total material used cost
SELECT 
    SUM(p.material_used * i.unit_price) AS total_material_cost , p.job_name
FROM dbo.production_orders_5x p
JOIN dbo.inventory_5x i
    ON p.product_id = i.prod_id;

	-- 4. Total material scrap cost per job
SELECT 
    p.job_name,
    SUM(p.material_scrap * i.unit_price) AS total_scrap_cost
FROM dbo.production_orders_5x p
JOIN dbo.inventory_5x i
    ON p.product_id = i.prod_id
GROUP BY p.job_name;

-- 5. Orders between date range
SELECT 
    production_order_id,
    product_id,
    job_name,
    ord_qty,
    ord_start_date,
    ord_end_date
FROM dbo.production_orders_5x
WHERE ord_start_date BETWEEN '2024-01-01' AND '2025-12-31';

-- 6. Average price used per production order
SELECT 
    p.production_order_id,
    AVG(i.unit_price) AS avg_price_used
FROM dbo.production_orders_5x p
JOIN dbo.inventory_5x i
    ON p.product_id = i.prod_id
GROUP BY p.production_order_id;

-- 7. Which job used most material
SELECT TOP 1
    job_name,
    SUM(material_used) AS total_material_used
FROM dbo.production_orders_5x
GROUP BY job_name
ORDER BY total_material_used DESC;

-- 8. Which job scrapped more
SELECT TOP 1
    job_name,
    SUM(material_scrap) AS total_scrap
FROM dbo.production_orders_5x
GROUP BY job_name
ORDER BY total_scrap DESC;

-- 9. Which category used more and scrapped more
SELECT 
    i.category,
    SUM(p.material_used) AS total_used,
    SUM(p.material_scrap) AS total_scrap
FROM dbo.production_orders_5x p
JOIN dbo.inventory_5x i
    ON p.product_id = i.prod_id
GROUP BY i.category
ORDER BY total_scrap DESC;

-- 10. Which job name took most days
SELECT TOP 1
    job_name,
    DATEDIFF(DAY, ord_start_date, ord_end_date) AS duration_days
FROM dbo.production_orders_5x
ORDER BY duration_days DESC;


-- 11. Which job is still in process
SELECT 
    production_order_id,
    job_name,
    status
FROM dbo.production_orders_5x
WHERE status = 'in progress';

-- 11. Which job is still in process
SELECT 
    production_order_id,
    job_name,
    status
FROM dbo.production_orders_5x
WHERE status = 'in progress';

-- 12. Which jobs have the highest average material used per order
SELECT 
    job_name,
    AVG(material_used * 1.0) AS avg_material_used
FROM dbo.production_orders_5x
GROUP BY job_name
ORDER BY avg_material_used DESC;

-- 13. Which products have high total inventory value but were never part of completed production orders
SELECT 
    i.prod_id,
    i.prod_name,
    i.total_price
FROM dbo.inventory_5x i
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.production_orders_5x p
    WHERE p.product_id = i.prod_id
      AND p.status = 'completed'
)
ORDER BY i.total_price DESC;


-- 14. Which production orders started late in the year and are still not completed
SELECT 
    production_order_id,
    product_id,
    job_name,
    ord_start_date,
    status
FROM dbo.production_orders_5x
WHERE MONTH(ord_start_date) >= 10
  AND status <> 'completed';

  -- 15. Which products contribute the most to total material scrap cost in the company
SELECT 
    i.prod_id,
    i.prod_name,
    SUM(p.material_scrap * i.unit_price) AS total_scrap_cost
FROM dbo.production_orders_5x p
JOIN dbo.inventory_5x i
    ON p.product_id = i.prod_id
GROUP BY i.prod_id, i.prod_name
ORDER BY total_scrap_cost DESC;

-- 16. Which job names have the highest total order quantity but also the highest average duration
SELECT 
    job_name,
    SUM(ord_qty) AS total_order_qty,
    AVG(DATEDIFF(DAY, ord_start_date, ord_end_date) * 1.0) AS avg_duration
FROM dbo.production_orders_5x
GROUP BY job_name
ORDER BY total_order_qty DESC, avg_duration DESC;

-- 17. Which categories are efficient in terms of low scrap but high production quantity
SELECT 
    i.category,
    SUM(p.ord_qty) AS total_production,
    SUM(p.material_scrap) AS total_scrap
FROM dbo.production_orders_5x p
JOIN dbo.inventory_5x i
    ON p.product_id = i.prod_id
GROUP BY i.category
ORDER BY total_scrap ASC, total_production DESC;

-- 18. Which products are both high price and slow moving
SELECT 
    i.prod_id,
    i.prod_name,
    i.unit_price,
    i.on_hand_qty
FROM dbo.inventory_5x i
LEFT JOIN dbo.production_orders_5x p
    ON i.prod_id = p.product_id
GROUP BY i.prod_id, i.prod_name, i.unit_price, i.on_hand_qty
HAVING COUNT(p.production_order_id) <= 2
ORDER BY i.unit_price DESC;

--19 . Which jobs or categories should be prioritized to reduce scrap cost without affecting production output
SELECT 
    i.category,
    SUM(p.material_scrap * i.unit_price) AS scrap_cost,
    SUM(p.ord_qty) AS production_qty
FROM dbo.production_orders_5x p
JOIN dbo.inventory_5x i
    ON p.product_id = i.prod_id
GROUP BY i.category
ORDER BY scrap_cost DESC, production_qty DESC;


-- 20. Which production orders have order quantity above average but material used cost below average
WITH cost_data AS (
    SELECT 
        p.production_order_id,
        p.product_id,
        p.ord_qty,
        CAST(p.material_used AS DECIMAL(20,2)) * CAST(i.unit_price AS DECIMAL(20,4)) AS material_cost
    FROM dbo.production_orders_5x p
    JOIN dbo.inventory_5x i
        ON p.product_id = i.prod_id
)
SELECT 
    production_order_id,
    product_id,
    ord_qty,
    material_cost
FROM cost_data
WHERE ord_qty > (
    SELECT AVG(CAST(ord_qty AS DECIMAL(20,2)))
    FROM dbo.production_orders_5x
)
AND material_cost < (
    SELECT AVG(material_cost)
    FROM cost_data
);



-- 21. Which jobs have the highest scrap cost percentage
SELECT 
    p.job_name,
    SUM(p.material_scrap * i.unit_price) * 100.0 /
    NULLIF(SUM(p.material_used * i.unit_price), 0) AS scrap_pct
FROM dbo.production_orders_5x p
JOIN dbo.inventory_5x i
    ON p.product_id = i.prod_id
GROUP BY p.job_name
ORDER BY scrap_pct DESC;

-- 22. Which production orders have the highest cost per unit produced
SELECT 
    p.production_order_id,
    p.product_id,
    (p.material_used * i.unit_price) / NULLIF(p.ord_qty, 0) AS cost_per_unit
FROM dbo.production_orders_5x p
JOIN dbo.inventory_5x i
    ON p.product_id = i.prod_id
ORDER BY cost_per_unit DESC;

-- 23. Which categories have the highest average inventory value per product
SELECT 
    category,
    AVG(total_price * 1.0) AS avg_inventory_value
FROM dbo.inventory_5x
GROUP BY category
ORDER BY avg_inventory_value DESC;

-- 24. Which categories have the highest average inventory value per product
SELECT 
    category,
    AVG(total_price * 1.0) AS avg_inventory_value
FROM dbo.inventory_5x
GROUP BY category
ORDER BY avg_inventory_value DESC;




-- 25. Which jobs have the longest average duration compared to others
SELECT 
    job_name,
    AVG(DATEDIFF(DAY, ord_start_date, ord_end_date) * 1.0) AS avg_duration,
    RANK() OVER (ORDER BY AVG(DATEDIFF(DAY, ord_start_date, ord_end_date) * 1.0) DESC) AS duration_rank
FROM dbo.production_orders_5x
GROUP BY job_name;

-- 29. Which categories have highest demand vs inventory gap
SELECT 
    i.category,
    SUM(i.on_hand_qty) AS inventory,
    SUM(p.ord_qty) AS demand,
    SUM(p.ord_qty) - SUM(i.on_hand_qty) AS gap
FROM dbo.inventory_5x i
JOIN dbo.production_orders_5x p
    ON i.prod_id = p.product_id
GROUP BY i.category
ORDER BY gap DESC;

-- 26. Which production orders are top 5 highest cost based on material used
SELECT TOP 5
    p.production_order_id,
    p.product_id,
    (p.material_used * i.unit_price) AS total_material_cost
FROM dbo.production_orders_5x p
JOIN dbo.inventory_5x i
    ON p.product_id = i.prod_id
ORDER BY total_material_cost DESC;