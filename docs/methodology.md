# Methodology

---

## Analytical approach

The project treats database design as an analytical tool, not just a storage mechanism. The schema is modeled as a star -- a single fact table (`Sales`) surrounded by six dimension tables (`Venue`, `Event`, `Booth`, `Product`, `Salesperson`, `Shift`) -- because the primary use case is answering multi-dimensional business questions, not simply recording transactions.

A flat table or denormalized spreadsheet could store the same data. But any query involving more than two entities (e.g., "revenue by product by event type") would require complex, error-prone lookups. The relational structure enforces correctness through foreign key constraints and enables arbitrary analytical combinations through JOINs.

---

## Design decisions

| Decision | Choice | Rationale |
|:---------|:-------|:----------|
| Normalization level | 3NF | Eliminates all transitive dependencies. Higher forms (BCNF, 4NF) offered no practical benefit for this dataset. |
| Primary key type | VARCHAR(9) | Readable IDs (VN1, EV1, SP1) aid debugging and manual inspection. Integer auto-increment would perform better at scale but reduces readability for a demonstration schema. |
| Schema pattern | Star | Optimizes analytical queries. Sales fact table joins cleanly to any dimension without intermediate hops. |
| Shift as bridge | Dual role (dimension + bridge) | Shift links Salesperson to Booth with temporal context. A pure junction table would lose the start/end time attributes. |
| Commission calculation | Query-time derived | Commission is calculated in the analytical query (`Total × 0.10`) rather than stored. Avoids sync issues if the rate changes. |
| Sample data volume | Minimal (2 records per table) | Enough to validate constraints and test all queries. Production data would follow the same INSERT pattern. |

---

## Assumptions and limitations

**Data assumptions:**
- Commission rate is fixed at 10% across all salespeople and products. A real deployment would likely store commission rates per salesperson or per product category.
- Each sale involves a single product. Basket-style transactions (multiple products in one sale) would require a `SaleLineItem` junction table.
- Shift assignments are non-overlapping. The schema does not enforce temporal non-overlap constraints -- a salesperson could theoretically be assigned two simultaneous shifts.

**Schema limitations:**
- No indexing is implemented beyond primary keys. Production deployment would need indexes on all foreign keys and frequently filtered columns (`Date_Time`, `Event_Type`).
- No stored procedures or triggers. Commission alerts, inventory warnings, and automated reports would require procedural logic.
- No partitioning strategy. The Sales table will grow fastest and would benefit from date-based partitioning in production.

---

## With more time and data

1. **Expand sample data** to 500-1000 transactions across 10+ events to make the analytical queries produce statistically meaningful patterns.
2. **Add indexing strategy** with benchmarked query plans showing before/after execution times.
3. **Build stored procedures** for commission calculation, monthly revenue reports, and event comparison summaries.
4. **Implement triggers** for data validation (e.g., reject sales where `Final_Selling_Price < Minimum_Selling_Price`).
5. **Add a customer dimension** to enable customer segmentation and repeat purchase analysis.
6. **Create views** for common analytical queries so downstream BI tools (Power BI, Tableau) can connect without writing SQL.
