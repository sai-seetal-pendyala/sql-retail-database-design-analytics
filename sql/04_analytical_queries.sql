-- =====================================================
-- Foxcore Retail Database
-- File: 04_analytical_queries.sql
-- Purpose:
--   Business-focused analytical queries to evaluate:
--   - Product performance by event
--   - Salesperson performance + estimated commission
--   - Revenue by event type
--   - Shift-level sales (staffing efficiency)
--   - Booth-level revenue (layout / placement effectiveness)
-- =====================================================


-- =====================================================
-- 1) Total Revenue and Units Sold by Product at Each Event
-- Business Question:
--   Which products perform best at different shows?
-- Use Case:
--   Identify product-market fit by event type to optimize
--   inventory allocation and marketing strategies.
-- =====================================================
SELECT
    e.Event_Name,
    p.ProductType,
    SUM(s.Quantity_Sold) AS Total_Units_Sold,
    SUM(s.Quantity_Sold * s.Final_Selling_Price) AS Total_Revenue
FROM Sales s
JOIN Product p ON s.Product_ID = p.Product_ID
JOIN Event e ON s.Event_ID = e.Event_ID
GROUP BY e.Event_Name, p.ProductType
ORDER BY Total_Revenue DESC;


-- =====================================================
-- 2) Sales and Commission Report per Salesperson
-- Business Question:
--   How much did each salesperson sell and what is their estimated commission?
-- Use Case:
--   Track individual performance, calculate accurate commissions,
--   and identify top performers for recognition and training opportunities.
-- Notes:
--   Commission rate used here = 10% (0.10)
-- =====================================================
SELECT
    sp.Salesperson_ID,
    sp.First_Name,
    sp.Last_Name,
    SUM(s.Quantity_Sold * s.Final_Selling_Price) AS Total_Sales,
    SUM(s.Quantity_Sold * s.Final_Selling_Price) * 0.10 AS Estimated_Commission
FROM Sales s
JOIN Shift sh ON s.Shift_ID = sh.Shift_ID
JOIN Salesperson sp ON sh.Salesperson_ID = sp.Salesperson_ID
GROUP BY sp.Salesperson_ID, sp.First_Name, sp.Last_Name
ORDER BY Total_Sales DESC;


-- =====================================================
-- 3) Total Revenue by Event Type
-- Business Question:
--   Which event types are most profitable?
-- Use Case:
--   Strategic decision-making for event selection, resource
--   allocation, and identifying high-value event categories.
-- =====================================================
SELECT
    e.Event_Type,
    COUNT(DISTINCT e.Event_ID) AS Number_of_Events,
    SUM(s.Quantity_Sold * s.Final_Selling_Price) AS Total_Revenue,
    AVG(s.Quantity_Sold * s.Final_Selling_Price) AS Average_Transaction_Value
FROM Sales s
JOIN Event e ON s.Event_ID = e.Event_ID
GROUP BY e.Event_Type
ORDER BY Total_Revenue DESC;


-- =====================================================
-- 4) Sales Per Shift by Salesperson
-- Business Question:
--   How much revenue is generated per shift?
-- Use Case:
--   Evaluate staffing efficiency, optimize shift scheduling,
--   and ensure accountability for sales performance.
-- =====================================================
SELECT
    sh.Shift_ID,
    sp.First_Name,
    sp.Last_Name,
    sh.Date,
    sh.Start_Time,
    sh.End_Time,
    -- Note: Shift duration calculation varies by database
    -- MySQL: TIMESTAMPDIFF(HOUR, sh.Start_Time, sh.End_Time)
    -- PostgreSQL: EXTRACT(HOUR FROM (sh.End_Time - sh.Start_Time))
    -- SQL Server: DATEDIFF(HOUR, sh.Start_Time, sh.End_Time)
    SUM(s.Quantity_Sold * s.Final_Selling_Price) AS Shift_Sales
FROM Shift sh
LEFT JOIN Sales s ON sh.Shift_ID = s.Shift_ID
JOIN Salesperson sp ON sh.Salesperson_ID = sp.Salesperson_ID
GROUP BY sh.Shift_ID, sp.First_Name, sp.Last_Name, sh.Date, sh.Start_Time, sh.End_Time
ORDER BY Shift_Sales DESC;


-- =====================================================
-- 5) Sales Breakdown by Booth and Event
-- Business Question:
--   Which booths generate the most revenue within each event?
-- Use Case:
--   Evaluate booth placement effectiveness, optimize layout
--   for future events, and identify high-traffic locations.
-- =====================================================
SELECT
    e.Event_Name,
    b.Booth_ID,
    b.Booth_Location,
    COUNT(DISTINCT s.Sale_ID) AS Number_of_Transactions,
    SUM(s.Quantity_Sold) AS Total_Units_Sold,
    SUM(s.Quantity_Sold * s.Final_Selling_Price) AS Booth_Revenue
FROM Sales s
JOIN Shift sh ON s.Shift_ID = sh.Shift_ID
JOIN Booth b ON sh.Booth_ID = b.Booth_ID
JOIN Event e ON s.Event_ID = e.Event_ID
GROUP BY e.Event_Name, b.Booth_ID, b.Booth_Location
ORDER BY Booth_Revenue DESC;


-- =====================================================
-- 6) Product Profitability Analysis
-- Business Question:
--   What is the profit margin for each product?
-- Use Case:
--   Identify most profitable products, optimize pricing
--   strategies, and make informed inventory decisions.
-- =====================================================
SELECT
    p.Product_ID,
    p.ProductType,
    p.Wholesale_Cost,
    p.Minimum_Selling_Price,
    AVG(s.Final_Selling_Price) AS Average_Selling_Price,
    AVG(s.Final_Selling_Price) - p.Wholesale_Cost AS Average_Profit_Per_Unit,
    ((AVG(s.Final_Selling_Price) - p.Wholesale_Cost) / AVG(s.Final_Selling_Price)) * 100 AS Profit_Margin_Percent,
    SUM(s.Quantity_Sold) AS Total_Units_Sold,
    SUM(s.Quantity_Sold * (s.Final_Selling_Price - p.Wholesale_Cost)) AS Total_Profit
FROM Product p
JOIN Sales s ON p.Product_ID = s.Product_ID
GROUP BY p.Product_ID, p.ProductType, p.Wholesale_Cost, p.Minimum_Selling_Price
ORDER BY Total_Profit DESC;

