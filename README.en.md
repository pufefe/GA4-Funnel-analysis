# GA4 Funnel & Channel Analysis

A personal analytics project: analyzing GA4 data (exported to BigQuery) to study the purchase funnel and channel performance. The goal was to practice SQL (CTEs, window functions, subqueries) on real GA4 data structures and extract actionable business insights.

## Stack

- **BigQuery** — data storage and processing (GA4 export schema)
- **SQL** — CTEs, window functions (`LAG`, `ROW_NUMBER`, `PARTITION BY`), subqueries (`IN`/`EXISTS`/scalar), `JOIN`, `GROUP BY`

## Repository structure

```
├── 1. Events (1st Nov to 31st Jan).sql   # raw event selection for the period
├── 2. Funnel users (CVR).sql             # users per funnel step
├── 3. Conversion.sql                     # step-over-step conversion
├── 4. CVR channel.sql                    # channel breakdown
└── README.md
```

## What `2. Funnel users (CVR).sql` and `3. Conversion.sql` do

Build the step-by-step GA4 event funnel (based on the selection from `1. Events (1st Nov to 31st Jan).sql`) and calculate step-over-step conversion (using the `LAG` window function to compare each step with the previous one).

- **view_item** — 61,252 users (start of the funnel)
- **add_to_cart** — 12,545 (conversion from previous step: 20.5%)
- **begin_checkout** — 9,715 (77.4%)
- **add_shipping_info** — 9,714 (100.0%)
- **add_payment_info** — 5,751 (59.2%)

**Key insight:** the biggest drop-off happens right after the product view step — only 20.5% of viewers go on to add an item to cart. The second weak point is between shipping info and payment (59.2%), where a significant share of near-paying users is lost.

## What `4. CVR channel.sql` does

Breaks down users by acquisition channel: volume (viewers), paying users (payers), and conversion to payment.

- **organic** — 21,652 viewers, 1,631 payers, 7.5% conversion
- **referral** — 17,580 viewers, 2,903 payers, **16.5%** conversion
- **none** — 10,783 viewers, 529 payers, 4.9% conversion
- **Other** — 8,184 viewers, 449 payers, 5.5% conversion
- **cpc** — 2,504 viewers, 136 payers, 5.4% conversion
- **data_deleted** — 549 viewers, 60 payers, 10.9% conversion

**Key insight:** referral isn't the largest channel by volume (it's second after organic), but it clearly outperforms every other channel in conversion quality — 16.5% vs. 7.5% for organic. This points to reallocating budget/effort toward referral traffic rather than simply scaling the largest channel.

## How to run

1. Open the BigQuery console (or use the `bq` CLI).
2. Run the queries in order: `1. Events (1st Nov to 31st Jan).sql`, then `2. Funnel users (CVR).sql` → `3. Conversion.sql` → `4. CVR channel.sql`, replacing `project.dataset.events_*` with your own table.
3. Export results to CSV and visualize as needed (this project's results were also visualized in Power BI — a funnel chart plus a channel performance dashboard).

## Author

Mikhailov Maksim — 3-rd year student of Saint-Petersburg National University of Economics (UNECON) in "Digitalization of Economic Activity"
