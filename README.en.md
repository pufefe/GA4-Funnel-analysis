# GA4 Funnel & Channel Analysis

An analytical pet project: exploring GA4 event data in BigQuery to analyze the purchase funnel and traffic channel performance. Goal — practice SQL (CTEs, window functions, subqueries) on real-world GA4 data structure and derive actionable business insights.

## Data

Public BigQuery dataset **`bigquery-public-data.ga4_obfuscated_sample_ecommerce`** — obfuscated (anonymized) event data from the Google Merchandise Store. Analysis period: **Nov 1, 2020 – Jan 31, 2021** (3 months), ~4.3M events.

## Stack

- **BigQuery** — data storage and processing (GA4 export schema)
- **SQL** — CTEs, window functions (`LAG`, `PARTITION BY`), subqueries, `JOIN`, `GROUP BY`, nested fields (`traffic_source.medium`)
- **Power BI** — visualization of the results (interactive dashboard with the funnel, channel breakdown, and a filter slicer)

## Repository structure

| File | What it does |
|---|---|
| `1. Events (1st Nov to 31st Jan).sql` | Sanity check — counts total events in the period to confirm the data connection and date range are correct |
| `2. Funnel users (CVR).sql` | Builds the funnel: counts unique users (`COUNT(DISTINCT user_pseudo_id)`) at each of the 5 purchase steps, ordered by business logic via `CASE` rather than alphabetically |
| `3. Conversion.sql` | Same funnel + step-to-step conversion rate (%) using the `LAG` window function to compare each step with the previous one without extra joins |
| `4. CVR channel.sql` | Breaks down users by acquisition channel (`traffic_source.medium`): how many viewed a product, how many reached payment, and the conversion rate per channel |

## Results

### Funnel (`2. Funnel users (CVR).sql`, `3. Conversion.sql`)

| Step | Users | Conversion from previous step |
|---|---|---|
| view_item | 61,252 | — |
| add_to_cart | 12,545 | 20.5% |
| begin_checkout | 9,715 | 77.4% |
| add_shipping_info | 9,714 | 100.0% |
| add_payment_info | 5,751 | 59.2% |

**Insight:** the widest drop-off is at the top of the funnel (view → cart, 20.5%), which is expected in e-commerce — people compare products before committing. The more concerning drop is at the very last step, shipping → payment (59.2%): these are high-intent users who already went through the entire flow. This is where the most "expensive" users for the business are lost.

### Channels (`4. CVR channel.sql`)

| Channel | Viewers | Payers | Conversion |
|---|---|---|---|
| organic | 21,652 | 1,631 | 7.5% |
| **referral** | 17,580 | 2,903 | **16.5%** |
| (none) | 10,783 | 529 | 4.9% |
| \<Other\> | 8,184 | 449 | 5.5% |
| cpc | 2,504 | 136 | 5.4% |
| (data deleted) | 549 | 60 | 10.9% |

**Insight:** organic drives the most traffic, but referral — with lower volume — converts more than twice as well (16.5% vs 7.5%) and brings in more actual buyers in absolute terms (2,903 vs 1,631). Traffic volume and traffic quality are different metrics: the largest channel isn't always the most effective one. Business takeaway — invest more in referral sources rather than only scaling the largest (organic) channel.

## Visualization

Results were exported to CSV and visualized in Power BI: an interactive dashboard with the step funnel, a combo chart for channels (volume + conversion), and a channel filter slicer.

## How to run

1. Open the BigQuery console (or the `bq` CLI) — the free Sandbox tier works, no billing required.
2. Run the queries in order (1 → 4) against the public dataset `bigquery-public-data.ga4_obfuscated_sample_ecommerce`.
3. Export the results to CSV and visualize them in any BI tool.

## Author

Maxim — student ("Digitalization of Economic Activity" track), preparing for a data analyst internship at Gazprom Neft's IT cluster.
