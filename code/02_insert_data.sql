-- =====================================================
-- Foxcore Retail Database
-- File: 02_insert_data.sql
-- Purpose:
--   Insert representative sample data into the
--   Foxcore Retail database for testing queries
--   and validating business logic.
--
-- Note:
--   Data reflects realistic event-based retail
--   operations with multiple products, staff,
--   shifts, and sales transactions.
-- =====================================================


-- =====================================================
-- VENUE DATA
-- =====================================================
INSERT INTO Venue (Venue_ID, Venue_Name, Address, Description)
VALUES
('VN1', 'Lakeside Pavilion', '789 Shoreline Dr, Toronto, ON M4C 1Z2, Canada', 'Scenic outdoor venue'),
('VN2', 'Expo Hall West', '12 King St, Toronto, ON M7B 2K4, Canada', NULL);


-- =====================================================
-- EVENT DATA
-- =====================================================
INSERT INTO Event (Event_ID, Event_Name, Start_Date, End_Date, Description, Event_Type, Venue_ID)
VALUES
('EV1', 'Summer Beats Fest', '2017-07-10', '2017-07-17', 'Live music and gourmet food trucks', 'Music Festival', 'VN1'),
('EV2', 'Urban Fitness Expo', '2017-08-12', '2017-08-13', 'Fitness demos and gear sales', 'Sporting Event', 'VN2');


-- =====================================================
-- BOOTH DATA
-- =====================================================
INSERT INTO Booth (Booth_ID, Booth_Location, Event_ID)
VALUES
('BT1', 'L11', 'EV1'),
('BT2', 'L12', 'EV2');


-- =====================================================
-- PRODUCT DATA
-- =====================================================
INSERT INTO Product (Product_ID, ProductType, Wholesale_Cost, Minimum_Selling_Price)
VALUES
('PT3', 'Glow Stick Set', 2.50, 10.00),
('PT4', 'Cooling Towel', 4.00, 15.00);


-- =====================================================
-- SALESPERSON DATA
-- =====================================================
INSERT INTO Salesperson (Salesperson_ID, First_Name, Last_Name, Address, Phone_Number)
VALUES
('SP1', 'Alicia', 'Reed', '1020 Carlton St, Toronto, Canada', 4163427888),
('SP2', 'Leo', 'Turner', '389 Queen St W, Toronto, Canada', 4379721164);


-- =====================================================
-- SHIFT DATA
-- =====================================================
INSERT INTO Shift (Shift_ID, Salesperson_ID, Booth_ID, Date, Start_Time, End_Time)
VALUES
('SF1', 'SP1', 'BT1', '2017-07-15', '11:00:00', '14:00:00'),
('SF2', 'SP2', 'BT2', '2017-08-12', '14:30:00', '17:30:00');


-- =====================================================
-- SALES TRANSACTION DATA
-- =====================================================
INSERT INTO Sales (Sale_ID, Product_ID, Shift_ID, Event_ID, Quantity_Sold, Final_Selling_Price, Date_Time)
VALUES
('S1', 'PT3', 'SF1', 'EV1', 12, 10.00, '2017-07-15 11:45:20'),
('S2', 'PT4', 'SF2', 'EV2', 7, 15.00, '2017-08-12 14:32:10');

