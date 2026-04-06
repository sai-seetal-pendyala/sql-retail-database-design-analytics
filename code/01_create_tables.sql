-- =====================================================
-- Foxcore Retail Database
-- File: 01_create_tables.sql
-- Purpose:
--   Create all tables for the Foxcore Retail relational
--   database with primary keys, foreign keys, and
--   integrity constraints.
--
-- Business Context:
--   Foxcore Retail operates multiple booths across
--   events, selling products through scheduled shifts.
--   This schema enables accurate sales tracking,
--   commission calculation, and performance analytics.
-- =====================================================


-- =====================================================
-- VENUE
-- Stores physical locations where events are hosted
-- =====================================================
CREATE TABLE Venue (
    Venue_ID        VARCHAR(9)  NOT NULL,
    Venue_Name      VARCHAR(50) NOT NULL,
    Address         VARCHAR(150) NOT NULL,
    Description     VARCHAR(150),

    CONSTRAINT PK_Venue PRIMARY KEY (Venue_ID)
);


-- =====================================================
-- EVENT
-- Stores event-level metadata and links each event 
-- to a single venue
-- =====================================================
CREATE TABLE Event (
    Event_ID        VARCHAR(9)  NOT NULL,
    Event_Name      VARCHAR(50) NOT NULL,
    Start_Date      DATE        NOT NULL,
    End_Date        DATE        NOT NULL,
    Description     VARCHAR(150) NOT NULL,
    Event_Type      VARCHAR(30) NOT NULL,
    Venue_ID        VARCHAR(9)  NOT NULL,

    CONSTRAINT PK_Event PRIMARY KEY (Event_ID),
    CONSTRAINT FK_Event_Venue FOREIGN KEY (Venue_ID)
        REFERENCES Venue (Venue_ID)
);


-- =====================================================
-- BOOTH
-- Represents individual sales booths assigned
-- to a specific event
-- =====================================================
CREATE TABLE Booth (
    Booth_ID        VARCHAR(9)  NOT NULL,
    Booth_Location  VARCHAR(25) NOT NULL,
    Event_ID        VARCHAR(9)  NOT NULL,

    CONSTRAINT PK_Booth PRIMARY KEY (Booth_ID),
    CONSTRAINT FK_Booth_Event FOREIGN KEY (Event_ID)
        REFERENCES Event (Event_ID)
);


-- =====================================================
-- PRODUCT
-- Stores product-level pricing and cost details
-- =====================================================
CREATE TABLE Product (
    Product_ID              VARCHAR(9)  NOT NULL,
    ProductType             VARCHAR(50) NOT NULL,
    Wholesale_Cost          DECIMAL(10,2) NOT NULL,
    Minimum_Selling_Price   DECIMAL(10,2) NOT NULL,

    CONSTRAINT PK_Product PRIMARY KEY (Product_ID)
);


-- =====================================================
-- SALESPERSON
-- Stores employee information for sales staff
-- =====================================================
CREATE TABLE Salesperson (
    Salesperson_ID  VARCHAR(9)  NOT NULL,
    First_Name      VARCHAR(30) NOT NULL,
    Last_Name       VARCHAR(30) NOT NULL,
    Address         VARCHAR(150),
    Phone_Number    BIGINT,

    CONSTRAINT PK_Salesperson PRIMARY KEY (Salesperson_ID)
);


-- =====================================================
-- SHIFT
-- Represents work shifts assigned to salespeople
-- at specific booths on a given date
-- =====================================================
CREATE TABLE Shift (
    Shift_ID        VARCHAR(9) NOT NULL,
    Salesperson_ID  VARCHAR(9) NOT NULL,
    Booth_ID        VARCHAR(9) NOT NULL,
    Date            DATE       NOT NULL,
    Start_Time      TIME       NOT NULL,
    End_Time        TIME       NOT NULL,

    CONSTRAINT PK_Shift PRIMARY KEY (Shift_ID),
    CONSTRAINT FK_Shift_Salesperson FOREIGN KEY (Salesperson_ID)
        REFERENCES Salesperson (Salesperson_ID),
    CONSTRAINT FK_Shift_Booth FOREIGN KEY (Booth_ID)
        REFERENCES Booth (Booth_ID)
);


-- =====================================================
-- SALES
-- Fact table storing transactional sales data
-- Links products, shifts, and events
-- =====================================================
CREATE TABLE Sales (
    Sale_ID             VARCHAR(9)  NOT NULL,
    Product_ID          VARCHAR(9)  NOT NULL,
    Shift_ID            VARCHAR(9)  NOT NULL,
    Event_ID            VARCHAR(9)  NOT NULL,
    Quantity_Sold       INT         NOT NULL,
    Final_Selling_Price DECIMAL(10,2) NOT NULL,
    Date_Time           DATETIME    NOT NULL,

    CONSTRAINT PK_Sales PRIMARY KEY (Sale_ID),
    CONSTRAINT FK_Sales_Product FOREIGN KEY (Product_ID)
        REFERENCES Product (Product_ID),
    CONSTRAINT FK_Sales_Shift FOREIGN KEY (Shift_ID)
        REFERENCES Shift (Shift_ID),
    CONSTRAINT FK_Sales_Event FOREIGN KEY (Event_ID)
        REFERENCES Event (Event_ID)
);

