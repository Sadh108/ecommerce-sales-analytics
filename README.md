# E-Commerce Sales Analytics

End-to-end data analytics project covering the full workflow of a real analyst task: messy raw data → Excel exploration → Python cleaning → SQL analysis → Power BI dashboard.

---

## Business Problem

The company wanted visibility into overall sales performance — revenue trends, top-performing products, regional performance, and order fulfillment health (cancellations/returns) — to identify where revenue is being lost and where to focus operational attention.

## Dataset

- **Source:** Synthetic e-commerce order-level dataset (3,110 rows, 21 columns), built to mirror real-world data quality issues.
- **Fields:** customer info (name, gender, DOB, email, phone, country, city, region), order info (product category, product name, quantity, unit price, discount, order date, payment mode, order status), and revenue.
- **Known data issues (intentional, to simulate a real messy dataset):**
  - Mixed date formats in `order_date` and `DOB`
  - Inconsistent text casing (`India` / `india` / `INDIA`, `UPI` / `upi`)
  - Missing values across `gender`, `country`, `pincode`, `customer_segment`, `revenue`
  - Invalid values — negative `quantity`, `discount` values above 100%
  - Duplicate rows and duplicate `order_id`s with conflicting data

## Tools Used

`Excel` · `Python (Pandas, NumPy)` · `SQL` · `Power BI`

## Process

**1. Excel — initial exploration**
- Used `TRIM()` and `PROPER()` to fix spacing and casing on name/category fields
- Used Conditional Formatting to visually flag negative quantities and invalid discounts
- Built quick pivot tables (Revenue by Category, Revenue by Region) to sanity-check the data before deeper cleaning

**2. Python — data cleaning**
- Renamed columns for consistency and dropped irrelevant fields
- Fixed data types (parsed mixed-format date strings into proper `datetime`)
- Standardized categorical values (`gender`, `country`, `payment_mode`, `order_status`)
- Filled missing values using existing data patterns (mode by group, business logic)
- Removed impossible values (negative quantity) and capped invalid discounts
- Recomputed `revenue` from `quantity × unit_price × (1 - discount)` instead of trusting missing/incorrect source values
- Removed exact duplicate rows; flagged (not blindly deleted) duplicate `order_id`s for review

**3. SQL — analysis**
- Loaded cleaned data and wrote queries for: monthly revenue trend, top 5 products by revenue, revenue by region/category, customer segment contribution %, order status breakdown, and repeat customers
- See [`sql/queries.sql`](sql/queries.sql)

**4. Power BI — dashboard**
- KPIs: Total Revenue, Total Orders, Average Order Value, Cancellation/Return Rate, Unique Customers
- Visuals: revenue trend (line), revenue by product category (bar), payment mode share (donut), order status by region (stacked bar), top products table
- Filters: Date Range, Region, Product Category, Customer Segment, Order Status, Payment Mode

## Key Insights

- **Cancellation/Return rate is 39%** — well above a healthy e-commerce benchmark of ~10-15%, flagging a fulfillment or product-quality issue rather than a one-off.
- **The high cancellation rate is spread fairly evenly across all four regions**, not concentrated in one — suggesting the root cause is more likely a product or logistics-process issue than a region-specific delivery problem.
- **Cash on Delivery and Credit Card together account for ~50% of order volume**, making payment mode a useful segment to investigate further against cancellation behavior.
- Top-performing products by revenue are concentrated in the Books and Sports categories, while overall monthly revenue shows a noticeable dip mid-year worth investigating against marketing/seasonality data.

## Recommendation

Investigate the fulfillment and returns process at a company-wide (not regional) level, and cross-analyze cancellation rate against payment mode and customer segment to isolate the root cause before assuming it's a logistics issue.

## Repository Structure

```
ecommerce-sales-analytics/
├── README.md
├── data/
│   ├── ecommerce_sales_raw.xlsx
│   └── ecommerce_sales_clean.csv
├── excel/
│   └── excel_cleaning_notes.xlsx
├── python/
│   ├── data_cleaning.ipynb
│   └── eda.ipynb
├── sql/
│   └── queries.sql
└── dashboard/
    ├── dashboard.pbix
    └── screenshots/
        └── dashboard_overview.png
```

## Known Limitations / Next Steps

- The regional map visual currently plots business-defined `region` (North/South/East/West) rather than a true geocodable location — a bar/treemap chart is a better fit and is planned as an update.
- Next iteration: add a customer master table and practice SQL joins (orders ↔ customers) to analyze repeat-purchase behavior more rigorously.
