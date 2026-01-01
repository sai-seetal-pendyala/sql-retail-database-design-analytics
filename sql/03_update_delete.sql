-- =====================================================
-- Foxcore Retail Database
-- File: 03_update_delete.sql
-- Purpose:
--   Demonstrate operational updates and deletions that
--   reflect realistic changes in event-based retail.
--
-- Notes:
--   - Run after 01_create_tables.sql and 02_insert_data.sql
--   - Updates reflect revised details (pricing, booth location,
--     event descriptions, staffing schedule changes)
--   - Deletes simulate discontinued products or removed records
-- =====================================================


-- =====================================================
-- UPDATE STATEMENTS
-- =====================================================

-- 1) Update Event description after finalizing event details
UPDATE Event
SET Description = 'Exciting live music performances and gourmet food trucks'
WHERE Event_ID = 'EV1';

-- 2) Update Venue description to reflect refined venue details
UPDATE Venue
SET Description = 'Beautiful outdoor space near the lakeside'
WHERE Venue_ID = 'VN1';

-- 3) Update Booth location due to booth re-assignment at the event venue
UPDATE Booth
SET Booth_Location = 'L13'
WHERE Booth_ID = 'BT1';

-- 4) Update Product wholesale cost due to supplier cost change
UPDATE Product
SET Wholesale_Cost = 3.00
WHERE Product_ID = 'PT3';

-- 5) Update Salesperson address due to updated employee details
UPDATE Salesperson
SET Address = '1050 New Carlton St, Toronto, ON M4C 1Z2, Canada'
WHERE Salesperson_ID = 'SP1';

-- 6) Update Sales final selling price to reflect revised pricing strategy
UPDATE Sales
SET Final_Selling_Price = 11.00
WHERE Sale_ID = 'S1';

-- 7) Update Shift start time due to scheduling adjustment
UPDATE Shift
SET Start_Time = '12:00:00'
WHERE Shift_ID = 'SF1';


-- =====================================================
-- DELETE STATEMENTS
-- =====================================================

-- NOTE:
-- Deletions can fail if dependent child records exist due to FK constraints.
-- For this sample, delete in dependency-safe order:
-- Sales -> Shift -> Booth -> Event -> Product -> Salesperson -> Venue

-- 1) Delete a Sales transaction (e.g., incorrect entry or refunded sale)
DELETE FROM Sales
WHERE Sale_ID = 'S2';

-- 2) Delete the related Shift (e.g., shift removed from schedule)
DELETE FROM Shift
WHERE Shift_ID = 'SF2';

-- 3) Delete the Booth (e.g., booth removed from event layout)
DELETE FROM Booth
WHERE Booth_ID = 'BT2';

-- 4) Delete the Event (e.g., event removed from active tracking)
DELETE FROM Event
WHERE Event_ID = 'EV2';

-- 5) Delete the Product (e.g., discontinued product line)
DELETE FROM Product
WHERE Product_ID = 'PT4';

-- 6) Delete the Salesperson record (e.g., employee no longer with company)
DELETE FROM Salesperson
WHERE Salesperson_ID = 'SP2';

-- 7) Delete the Venue record (e.g., venue removed from system)
DELETE FROM Venue
WHERE Venue_ID = 'VN2';

