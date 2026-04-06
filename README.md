<p align="center">
  <img src="assets/banner.svg" alt="Event retail database and SQL analytics" width="100%"/>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/SQL-Database-00D4C8?style=flat-square&logo=postgresql&logoColor=white"/>
  <img src="https://img.shields.io/badge/3NF-Normalized-00D4C8?style=flat-square"/>
  <img src="https://img.shields.io/badge/Star_Schema-Analytical-00D4C8?style=flat-square"/>
  <img src="https://img.shields.io/badge/License-MIT-F5F5F0?style=flat-square"/>
</p>

---

A pop-up retailer runs booths at music festivals, fitness expos, and sporting events across Ontario. Sales lived in spreadsheets, commissions took hours to calculate by hand, and nobody could answer the most basic questions -- which products sell best at which events, which booth locations drive the most revenue, or which salespeople earn their shifts. This project builds a normalized relational database from the ground up: **7 tables in third normal form, a star schema designed for analytics, and 6 business intelligence queries that turn fragmented transaction data into decisions about where to show up, what to stock, and who to schedule**.

> Case study scenario: [Foxcore Retail (PDF)](docs/Case%20Study%20-%20Foxcore%20Retail.pdf)

---

<table width="100%">
<tr>
<td align="center" width="25%" valign="top">
<h1>7</h1>
<hr>
tables in third normal form
</td>
<td align="center" width="25%" valign="top">
<h1>6</h1>
<hr>
business intelligence queries
</td>
<td align="center" width="25%" valign="top">
<h1>6+1</h1>
<hr>
dimension tables plus one fact table
</td>
<td align="center" width="25%" valign="top">
<h1>3NF</h1>
<hr>
zero data redundancy
</td>
</tr>
</table>

---

## Contents

| **Section** | **What you'll find** |
|---|---|
| [Project snapshot](#project-snapshot) | Quick-glance specs |
| [The problem](#the-problem) | Why spreadsheets were costing the business |
| [Database design](#database-design) | 7 tables, star schema, normalization |
| [Analytical queries](#analytical-queries) | 6 business questions answered in SQL |
| [Key findings](#key-findings) | What the data reveals |
| [Business impact](#business-impact) | Decisions this system enables |
| [Reproduce it](#reproduce-it) | Clone, create, query |

---

## Project snapshot

| **Domain** | Retail operations, event-based sales |
|---|---|
| **Context** | Database design for an Ontario pop-up retail startup |
| **School** | Illinois Institute of Technology |
| **Tools** | SQL (DDL, DML, analytical queries) |
| **Methods** | ER modeling, 3NF normalization, star schema design |
| **Schema** | 7 tables -- 1 fact table, 6 dimension tables |

---

## The problem

The business operates pop-up sales booths at music festivals, fitness expos, and sporting events across Ontario. A team of salespeople rotates through booths at different venues, selling products ranging from glow sticks to cooling towels and earning commissions on each transaction.

As the operation expanded from one or two events to a multi-venue calendar, everything broke. Sales were tracked in disconnected spreadsheets -- one per event, sometimes one per salesperson. Commission calculations required 4-6 hours of manual reconciliation each pay period. Product performance across event types was invisible. Booth placement decisions were pure guesswork. Each new event meant another spreadsheet, another reconciliation process, another chance for errors to compound.

| **Problem** | **Scale** |
|---|---|
| Fragmented sales data | Separate spreadsheets per event, per salesperson |
| Manual commission calculation | 4-6 hours per pay period |
| No product-event analytics | Zero visibility into what sells where |
| Booth placement guesswork | No data on which locations drive revenue |
| Scaling pain | Each new event multiplied manual effort linearly |

The fundamental question: how do you capture the full chain from venue to event to booth to shift to salesperson to sale to product -- and make the whole thing queryable in seconds?

---

## Database design

<p align="center">
  <img src="assets/ERD.png" alt="Entity Relationship Diagram -- 7 entities with full cardinality" width="100%"/>
</p>

The schema follows a **star pattern** with `Sales` as the central fact table and six dimension tables radiating outward. Every relationship is enforced through foreign key constraints -- no orphaned records, no referential integrity violations.

<p align="center">
  <img src="assets/relational_schema.png" alt="Relational schema -- 7 tables with primary and foreign key mappings" width="100%"/>
</p>

<table width="100%">
<tr>
<td align="center" width="33%" valign="top">
<h3>Dimension tables</h3>
<hr>
Venue, Event, Booth, Product, Salesperson, Shift<br><br>Reference data that describes business entities -- relatively static, frequently joined
</td>
<td align="center" width="33%" valign="top">
<h3>Fact table</h3>
<hr>
Sales<br><br>Transactional data linking products, shifts, and events with quantities and prices
</td>
<td align="center" width="33%" valign="top">
<h3>Bridge table</h3>
<hr>
Shift (also bridges Salesperson and Booth)<br><br>Temporal assignment linking who works where and when
</td>
</tr>
</table>

**Normalization to 3NF:**

1. **1NF** -- All attributes contain atomic values. No repeating groups, no multi-valued cells.
2. **2NF** -- Every non-key attribute is fully dependent on the entire primary key. No partial dependencies.
3. **3NF** -- No transitive dependencies. Removing a non-key column never changes the meaning of another non-key column.

The result: zero redundancy, predictable updates, and a schema that handles growth without restructuring.

<p align="center">
  <img src="assets/normalization_3NF.png" alt="Third normal form normalization -- dependency analysis for all 7 tables" width="100%"/>
</p>

> Full architecture details: [ARCHITECTURE.md](docs/ARCHITECTURE.md) | Complete column reference: [DATABASE_DICTIONARY.md](docs/DATABASE_DICTIONARY.md)

---

## Analytical queries

Six queries built to answer questions that spreadsheet-only operations could not answer reliably. Each query traverses multiple tables through JOINs, demonstrating the analytical power of a properly normalized schema.

<table width="100%">
<tr>
<th align="left" width="5%">#</th>
<th align="left" width="30%">Business question</th>
<th align="left" width="35%">What the query does</th>
<th align="left" width="30%">Key JOINs</th>
</tr>
<tr>
<td>1</td>
<td>Which products perform best at different events?</td>
<td>Total revenue and units sold by product at each event</td>
<td>Sales → Product → Event</td>
</tr>
<tr>
<td>2</td>
<td>How much did each salesperson sell and what's their commission?</td>
<td>Per-person sales totals with 10% commission calculation</td>
<td>Sales → Shift → Salesperson</td>
</tr>
<tr>
<td>3</td>
<td>Which event types generate the most revenue?</td>
<td>Revenue and average transaction value by event category</td>
<td>Sales → Event (grouped by type)</td>
</tr>
<tr>
<td>4</td>
<td>How productive is each shift?</td>
<td>Revenue per shift with salesperson and time window</td>
<td>Sales → Shift → Salesperson</td>
</tr>
<tr>
<td>5</td>
<td>Which booth locations drive the most sales?</td>
<td>Transaction count, units, and revenue by booth within each event</td>
<td>Sales → Shift → Booth → Event</td>
</tr>
<tr>
<td>6</td>
<td>What are the true profit margins by product?</td>
<td>Average selling price, profit per unit, margin %, and total profit</td>
<td>Sales → Product (with calculated fields)</td>
</tr>
</table>

**Query 1 -- Product performance by event** answers the inventory question. If glow sticks outsell cooling towels 3:1 at music festivals but cooling towels dominate at fitness expos, you stock differently for each event type.

**Query 2 -- Commission tracking** eliminates the 4-6 hour manual reconciliation entirely. Every sale links through a shift to the salesperson who made it. Commission = `Total Sales × 10%`, calculated automatically.

**Query 5 -- Booth-level revenue** is the one that changes real decisions. When negotiating booth placement at a venue, having data on which locations generated the most revenue gives you leverage. "L11 outperformed L12 by 40% at the same event" is a sentence spreadsheets could never produce.

**Query 6 -- Product profitability** surfaces the gap between revenue and actual profit. A product can look like a top seller on units but have thin margins. This query calculates `(Final_Selling_Price - Wholesale_Cost) / Final_Selling_Price × 100` to expose the real number.

---

## Key findings

The database design reveals that event-based retail analytics requires crossing at least three entity boundaries to produce useful insights. No single table contains enough context to answer a real business question.

**1. Multi-table JOINs are not optional -- they're the point.** The most useful query (booth-level revenue) requires traversing Sales → Shift → Booth → Event. Without referential integrity linking these tables, this analysis is impossible in spreadsheets.

**2. Commission accuracy scales with transaction volume.** In a spreadsheet, each new transaction increases the chance of a calculation error. In the database, commission is a derived column that's always correct regardless of volume.

**3. Product-market fit varies by event type.** Music festivals, trade shows, and sporting events attract different audiences with different purchase patterns. The product-by-event query makes this visible for the first time.

**4. Booth placement is a revenue lever.** Location within a venue affects sales volume. The booth revenue query creates a feedback loop: measure performance, negotiate better placements, measure again.

---

## Business impact

Before this system, every business question required someone to open multiple spreadsheets, manually cross-reference rows, and hope the formulas were right. The database replaces that entire process with queries that run in milliseconds.

**For the operations manager:** Commission disputes disappear. Every sale maps to a shift, every shift maps to a salesperson. The 4-6 hour manual calculation becomes a single query. Payroll processing goes from a day-long headache to a 30-second report.

**For the event planner:** The revenue-by-event-type query tells you which events to attend again and which to skip. Combined with booth-level data, you can negotiate specific locations at proven venues instead of accepting whatever's available.

**For the merchandiser:** Product profitability by event type means you stop bringing slow-moving inventory to the wrong events. High-margin items get shelf space at events where they sell. Low-margin items get re-priced or dropped.

The system also scales. Adding a new venue, event, product, or salesperson requires nothing more than INSERT statements that inherit the full constraint and query infrastructure automatically.

---

## Reproduce it

```bash
git clone https://github.com/sai-seetal-pendyala/sql-retail-database-design-analytics.git
cd sql-retail-database-design-analytics
```

**Run in any SQL environment (MySQL, PostgreSQL, SQL Server):**

```sql
-- Step 1: Create all tables with constraints
-- Run code/01_create_tables.sql

-- Step 2: Insert sample data
-- Run code/02_insert_data.sql

-- Step 3: Test updates and deletes
-- Run code/03_update_delete.sql

-- Step 4: Run analytical queries
-- Run code/04_analytical_queries.sql
```

Each SQL file is self-contained and documented. Run them in order -- the foreign key constraints require parent tables to exist before child data is inserted.

---

<p align="center">
  Part of <b>Sai Seetal Pendyala</b>'s Analytics Portfolio<br>
  <a href="https://www.linkedin.com/in/sai-seetal-pendyala/">LinkedIn</a> · <a href="https://github.com/sai-seetal-pendyala">GitHub</a>
</p>
