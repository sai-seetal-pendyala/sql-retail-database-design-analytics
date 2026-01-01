# Foxcore Retail Database Dictionary

Complete reference guide for all tables, columns, relationships, and constraints in the Foxcore Retail database system.

---

## Table of Contents

- [Venue](#venue)
- [Event](#event)
- [Booth](#booth)
- [Product](#product)
- [Salesperson](#salesperson)
- [Shift](#shift)
- [Sales](#sales)
- [Relationships Summary](#relationships-summary)

---

## Venue

Stores physical locations where events are hosted.

| Column Name | Data Type | Constraints | Description |
|-------------|-----------|-------------|-------------|
| **Venue_ID** | VARCHAR(9) | PRIMARY KEY, NOT NULL | Unique identifier for each venue |
| **Venue_Name** | VARCHAR(50) | NOT NULL | Name of the venue |
| **Address** | VARCHAR(150) | NOT NULL | Full address of the venue |
| **Description** | VARCHAR(150) | NULL | Optional description of venue features |

**Example Values:**
- Venue_ID: 'VN1'
- Venue_Name: 'Lakeside Pavilion'
- Address: '789 Shoreline Dr, Toronto, ON M4C 1Z2, Canada'
- Description: 'Scenic outdoor venue'

**Business Rules:**
- Each venue can host zero, one, or many events
- Venue names must be unique for clarity
- Address is required for event planning and logistics

---

## Event

Stores event-level metadata and links each event to a single venue.

| Column Name | Data Type | Constraints | Description |
|-------------|-----------|-------------|-------------|
| **Event_ID** | VARCHAR(9) | PRIMARY KEY, NOT NULL | Unique identifier for each event |
| **Event_Name** | VARCHAR(50) | NOT NULL | Name of the event |
| **Start_Date** | DATE | NOT NULL | Event start date |
| **End_Date** | DATE | NOT NULL | Event end date |
| **Description** | VARCHAR(150) | NOT NULL | Description of the event |
| **Event_Type** | VARCHAR(30) | NOT NULL | Category of event (e.g., Music Festival, Sporting Event) |
| **Venue_ID** | VARCHAR(9) | FOREIGN KEY, NOT NULL | References Venue.Venue_ID |

**Example Values:**
- Event_ID: 'EV1'
- Event_Name: 'Summer Beats Fest'
- Start_Date: '2017-07-10'
- End_Date: '2017-07-17'
- Description: 'Live music and gourmet food trucks'
- Event_Type: 'Music Festival'
- Venue_ID: 'VN1'

**Business Rules:**
- Each event must be associated with exactly one venue
- End_Date must be greater than or equal to Start_Date
- Event_Type helps categorize events for analytics

**Foreign Key Relationships:**
- Venue_ID → Venue.Venue_ID (Many-to-One)

---

## Booth

Represents individual sales booths assigned to a specific event.

| Column Name | Data Type | Constraints | Description |
|-------------|-----------|-------------|-------------|
| **Booth_ID** | VARCHAR(9) | PRIMARY KEY, NOT NULL | Unique identifier for each booth |
| **Booth_Location** | VARCHAR(25) | NOT NULL | Physical location identifier within venue (e.g., 'L11', 'L12') |
| **Event_ID** | VARCHAR(9) | FOREIGN KEY, NOT NULL | References Event.Event_ID |

**Example Values:**
- Booth_ID: 'BT1'
- Booth_Location: 'L11'
- Event_ID: 'EV1'

**Business Rules:**
- Each booth must be associated with exactly one event
- Booth_Location should be unique within an event
- Multiple booths can exist at the same event

**Foreign Key Relationships:**
- Event_ID → Event.Event_ID (Many-to-One)

---

## Product

Stores product-level pricing and cost details.

| Column Name | Data Type | Constraints | Description |
|-------------|-----------|-------------|-------------|
| **Product_ID** | VARCHAR(9) | PRIMARY KEY, NOT NULL | Unique identifier for each product |
| **ProductType** | VARCHAR(50) | NOT NULL | Name/type of the product |
| **Wholesale_Cost** | DECIMAL(10,2) | NOT NULL | Cost to purchase product from supplier |
| **Minimum_Selling_Price** | DECIMAL(10,2) | NOT NULL | Minimum acceptable selling price |

**Example Values:**
- Product_ID: 'PT3'
- ProductType: 'Glow Stick Set'
- Wholesale_Cost: 2.50
- Minimum_Selling_Price: 10.00

**Business Rules:**
- Minimum_Selling_Price must be greater than Wholesale_Cost
- ProductType should be descriptive for reporting
- Products can have zero, one, or many sales

**Calculated Fields:**
- Profit Margin = Final_Selling_Price - Wholesale_Cost
- Profit Percentage = ((Final_Selling_Price - Wholesale_Cost) / Final_Selling_Price) × 100

---

## Salesperson

Stores employee information for sales staff.

| Column Name | Data Type | Constraints | Description |
|-------------|-----------|-------------|-------------|
| **Salesperson_ID** | VARCHAR(9) | PRIMARY KEY, NOT NULL | Unique identifier for each salesperson |
| **First_Name** | VARCHAR(30) | NOT NULL | First name of salesperson |
| **Last_Name** | VARCHAR(30) | NOT NULL | Last name of salesperson |
| **Address** | VARCHAR(150) | NULL | Contact address |
| **Phone_Number** | BIGINT | NULL | Contact phone number |

**Example Values:**
- Salesperson_ID: 'SP1'
- First_Name: 'Alicia'
- Last_Name: 'Reed'
- Address: '1020 Carlton St, Toronto, Canada'
- Phone_Number: 4163427888

**Business Rules:**
- Each salesperson must be assigned to at least one shift
- Phone numbers stored as integers (format: country code + number)
- Address is optional but recommended for payroll

**Foreign Key Relationships:**
- Referenced by Shift.Salesperson_ID (One-to-Many)

---

## Shift

Represents work shifts assigned to salespeople at specific booths on a given date.

| Column Name | Data Type | Constraints | Description |
|-------------|-----------|-------------|-------------|
| **Shift_ID** | VARCHAR(9) | PRIMARY KEY, NOT NULL | Unique identifier for each shift |
| **Salesperson_ID** | VARCHAR(9) | FOREIGN KEY, NOT NULL | References Salesperson.Salesperson_ID |
| **Booth_ID** | VARCHAR(9) | FOREIGN KEY, NOT NULL | References Booth.Booth_ID |
| **Date** | DATE | NOT NULL | Date of the shift |
| **Start_Time** | TIME | NOT NULL | Shift start time |
| **End_Time** | TIME | NOT NULL | Shift end time |

**Example Values:**
- Shift_ID: 'SF1'
- Salesperson_ID: 'SP1'
- Booth_ID: 'BT1'
- Date: '2017-07-15'
- Start_Time: '11:00:00'
- End_Time: '14:00:00'

**Business Rules:**
- End_Time must be greater than Start_Time
- Each shift is assigned to exactly one salesperson and one booth
- Shifts can have zero, one, or many sales transactions
- Date, Start_Time, and End_Time together define the shift period

**Foreign Key Relationships:**
- Salesperson_ID → Salesperson.Salesperson_ID (Many-to-One)
- Booth_ID → Booth.Booth_ID (Many-to-One)
- Referenced by Sales.Shift_ID (One-to-Many)

**Calculated Fields:**
- Shift Duration = End_Time - Start_Time
- Revenue Per Hour = Total Sales / Shift Duration

---

## Sales

Fact table storing transactional sales data. Links products, shifts, and events.

| Column Name | Data Type | Constraints | Description |
|-------------|-----------|-------------|-------------|
| **Sale_ID** | VARCHAR(9) | PRIMARY KEY, NOT NULL | Unique identifier for each sale transaction |
| **Product_ID** | VARCHAR(9) | FOREIGN KEY, NOT NULL | References Product.Product_ID |
| **Shift_ID** | VARCHAR(9) | FOREIGN KEY, NOT NULL | References Shift.Shift_ID |
| **Event_ID** | VARCHAR(9) | FOREIGN KEY, NOT NULL | References Event.Event_ID |
| **Quantity_Sold** | INT | NOT NULL | Number of units sold in this transaction |
| **Final_Selling_Price** | DECIMAL(10,2) | NOT NULL | Actual price per unit at time of sale |
| **Date_Time** | DATETIME | NOT NULL | Timestamp of the sale transaction |

**Example Values:**
- Sale_ID: 'S1'
- Product_ID: 'PT3'
- Shift_ID: 'SF1'
- Event_ID: 'EV1'
- Quantity_Sold: 12
- Final_Selling_Price: 10.00
- Date_Time: '2017-07-15 11:45:20'

**Business Rules:**
- Quantity_Sold must be greater than 0
- Final_Selling_Price should be greater than or equal to Product.Minimum_Selling_Price
- Date_Time must fall within the associated Shift's date and time range
- Each sale is associated with exactly one product, one shift, and one event

**Foreign Key Relationships:**
- Product_ID → Product.Product_ID (Many-to-One)
- Shift_ID → Shift.Shift_ID (Many-to-One)
- Event_ID → Event.Event_ID (Many-to-One)

**Calculated Fields:**
- Transaction Total = Quantity_Sold × Final_Selling_Price
- Profit = Quantity_Sold × (Final_Selling_Price - Wholesale_Cost)
- Commission = Transaction Total × Commission_Rate (typically 10%)

---

## Relationships Summary

### One-to-Many Relationships

1. **Venue → Event**
   - One venue can host many events
   - Each event belongs to one venue

2. **Event → Booth**
   - One event can have many booths
   - Each booth belongs to one event

3. **Event → Sales**
   - One event can have many sales
   - Each sale belongs to one event

4. **Booth → Shift**
   - One booth can have many shifts
   - Each shift belongs to one booth

5. **Salesperson → Shift**
   - One salesperson can work many shifts
   - Each shift is worked by one salesperson

6. **Product → Sales**
   - One product can be sold in many transactions
   - Each sale involves one product

7. **Shift → Sales**
   - One shift can generate many sales
   - Each sale occurs during one shift

### Referential Integrity

All foreign key relationships enforce referential integrity:
- Cannot delete a parent record if child records exist (unless CASCADE is specified)
- Cannot insert a child record with a non-existent parent key
- Updates to primary keys propagate to foreign keys (if CASCADE is specified)

---

## Data Types Reference

| Data Type | Description | Usage |
|-----------|-------------|-------|
| VARCHAR(n) | Variable-length string up to n characters | IDs, names, descriptions |
| DATE | Date value (YYYY-MM-DD) | Event dates, shift dates |
| TIME | Time value (HH:MM:SS) | Shift start/end times |
| DATETIME | Date and time value | Sale timestamps |
| DECIMAL(10,2) | Fixed-point decimal with 10 digits, 2 decimal places | Prices, costs, revenue |
| INT | Integer value | Quantities, counts |
| BIGINT | Large integer value | Phone numbers |

---

## Indexing Recommendations

For optimal query performance, consider creating indexes on:

- **Event.Venue_ID** - Frequently joined with Venue
- **Booth.Event_ID** - Frequently joined with Event
- **Shift.Salesperson_ID** - Frequently joined with Salesperson
- **Shift.Booth_ID** - Frequently joined with Booth
- **Sales.Product_ID** - Frequently joined with Product
- **Sales.Shift_ID** - Frequently joined with Shift
- **Sales.Event_ID** - Frequently joined with Event
- **Sales.Date_Time** - Used for time-based queries

---

## Constraints Summary

### Primary Keys
- All tables have a single-column primary key
- Primary keys are VARCHAR(9) for most tables
- Ensures unique identification of each record

### Foreign Keys
- All foreign keys reference valid primary keys
- Foreign key constraints prevent orphaned records
- Maintains referential integrity across the database

### NOT NULL Constraints
- Critical fields (IDs, names, dates, prices) are NOT NULL
- Optional fields (descriptions, addresses) allow NULL values
- Ensures data completeness for essential information

---

*Last Updated: 2024*

