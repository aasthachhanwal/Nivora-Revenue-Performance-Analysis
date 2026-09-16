# Nivora-Revenue-Performance-Analysis
SQL and Power BI analysis of revenue, customer retention and dark-store performance for a hypothetical quick-commerce (grocery &amp; essentials)business.
Nivora: Revenue, Retention & Dark-Store Performance Analysis

Nivora is a hypothetical Delhi-NCR quick-commerce business operating
through a network of dark stores. This project uses a synthetic
transactional dataset to analyse revenue performance, customer retention
and store-level operational performance using PostgreSQL and Power BI.

The analysis was built around a practical business question: where is
revenue concentrated, how are customers behaving after their first
purchase, and which operational patterns are worth investigating?

Project Overview

The project brings together commercial, customer and operational
analysis rather than looking at revenue in isolation. I used SQL to
create and validate the dataset, investigate revenue and order trends,
compare stores and categories, analyse customer retention and evaluate
promotion performance. Power BI was then used to turn the analysis into
a business-facing dashboard.

The dataset is synthetic and was created specifically for this project.
Nivora is not a real company, and the results should be read as findings
from a portfolio case study rather than actual company performance.

Business Problem

For a quick-commerce business, overall growth can hide differences
between stores, categories and customer groups. A store may generate
strong revenue while also experiencing higher cancellations or delivery
delays, while a customer acquisition campaign may bring in first-time
buyers without necessarily improving repeat purchasing.

The analysis therefore focused on four areas: revenue and order
performance over time, store and category contribution, customer repeat
behaviour and cohort retention, and the relationship between operational
metrics such as cancellations and delivery delays and customer
behaviour.

Data

The PostgreSQL database contains eight related tables: customers,
dark_stores, products, promotions, orders, order_items, deliveries and
order_promotions.

The dataset includes 7,500 customers, 8 dark stores, 30 products and 6
promotion types, along with order, product, delivery and promotion-level
transactions. The SQL script generates the data and establishes the
required primary and foreign-key relationships.

The complete SQL script is available in the sql folder as
Nivora_Rev_Perf_Analysis.sql.

Data Validation

Before carrying out the business analysis, I included checks for basic
data integrity. These cover row counts, invalid customer and store
links, order-value reconciliation against order items, delivery-delay
buckets, orders recorded before a store launch date, and completed
orders without delivery records.

For completed orders, the recorded order value is also checked against
the sum of quantity multiplied by selling price at the order-item level.

SQL Analysis

The SQL analysis covers monthly revenue, order volume, average order
value and month-on-month revenue growth. Store-level analysis compares
revenue, orders, AOV, cancellation rates and delivery delays, while
category analysis looks at revenue, units sold and revenue per order.

Customer analysis examines repeat customers, order depth and cohort
retention. Promotion analysis looks at promoted orders, revenue, AOV and
the share of promoted orders that were first purchases.

The analysis uses joins, aggregations, CASE statements, CTEs,
subqueries, date functions and window functions including ROW_NUMBER and
LAG.

Power BI

The SQL data was imported into Power BI Desktop and connected through
relationships between the customer, store, product and promotion tables
and the order-level transaction tables.

The model includes relationships between customers and orders, dark
stores and orders, orders and deliveries, orders and order items,
products and order items, and orders and promotions through the
order_promotions table.

The report uses DAX measures for revenue, completed orders, AOV,
cancellation rate, average delivery delay, repeat customer rate, repeat
revenue share, 3+ order customer rate, cohort retention, first-order
promotion penetration and first-order delay exposure, among other
supporting measures.

Dashboard

Revenue, Store & Category Performance

The first dashboard page provides an overview of commercial performance.
It covers revenue, completed orders, AOV, revenue concentration by store
and category, monthly revenue movement, category sales, store
cancellation rates and average delivery delays.

The dashboard reports approximately ₹15.7M in completed-order revenue,
with Staples contributing about 55% of revenue and the largest store (Saket)
contributing about 26%.



Customer, Retention & Operations

The second page focuses on customer behaviour and operational exposure.
It includes customer order depth, repeat-rate comparisons by first-order
promotion status, repeat-rate comparisons by first-order delivery-delay
bucket, cohort retention, promotion revenue contribution and store-level
customer metrics.

The dashboard reports a repeat customer rate of approximately 89.9% and
repeat revenue share of approximately 73.3%.

The largest difference in repeat rate appears across first-order
delivery-delay groups. Customers in the 0--10 minute group show a 94.5%
repeat rate, compared with 68.6% for customers whose first order was
delayed by more than 21 minutes.

The promotion comparison is much smaller. The displayed repeat rate is
90.3% for customers whose first order used a promotion and 89.0% for
those whose first order did not, a difference of approximately 1.3
percentage points.



Key Findings

Revenue is concentrated across a relatively small number of stores and
categories. Staples is the largest category in the dataset, accounting
for about 55% of revenue, while the largest store contributes about 26%.

Store-level operational performance also varies considerably. Dwarka and
Ghaziabad show the highest cancellation rates in the dashboard, at 13.9%
and 12.8%, respectively. Their average delivery delays are also
substantially higher, at 31.8 and 31.5 minutes.

Customer repeat purchasing is high overall, with 6,694 repeat customers
out of 7,446 purchasing customers. Repeat customers account for
approximately 73.3% of revenue in the dashboard.

The strongest customer-level pattern is associated with first-order
delivery delay. The repeat rate is substantially lower for the 21+
minute delay group than for the lower-delay groups. Because the dataset
is synthetic and the generation logic deliberately introduces
store-level differences in delays and cancellations, this should be
treated as an observed association rather than evidence that delivery
delay directly causes lower retention.

The first-order promotion comparison shows only a small repeat-rate
difference. This suggests that promotion usage alone does not explain
much of the repeat-rate variation in this dataset.

Business Interpretation

The results point to a few areas that would be worth investigating
further in a real business.

Stores with higher delays and cancellations would warrant operational
root-cause analysis, including investigation of order density, staffing,
picking and packing capacity, inventory availability and delivery
capacity.

The concentration of revenue in Staples and a small number of stores
also suggests that availability and operational reliability in these
areas could have a disproportionate effect on overall performance.

The first-order delay pattern makes the early customer experience
particularly relevant for further analysis. In a real dataset, this
relationship should be tested while controlling for store, acquisition
channel, order value, customer geography, promotion usage, product mix
and time of day.

Promotion performance should also be evaluated on incremental behaviour
and economics rather than repeat rate alone. A real analysis could
compare incremental conversion, repeat orders, revenue, contribution
margin and customer lifetime value.

Limitations

This is a synthetic portfolio case study, so the numbers do not
represent an actual quick-commerce company.

The data-generation process intentionally creates variation in store
cancellations, delivery delays and customer ordering behaviour. This
makes the dataset useful for demonstrating analytical techniques, but it
also means that relationships found in the data cannot be treated as
unbiased real-world evidence.

The retention analysis uses customer signup month as the cohort
definition and then tracks completed-order activity in later months. It
is therefore a signup-based cohort analysis rather than a first-purchase
cohort analysis.

The Power BI report was built in Power BI Desktop. The repository
contains screenshots of the dashboard and data model rather than a
published Power BI Service report.

Repository

The repository contains the README, the PostgreSQL SQL script in the sql folder, and the Power BI dashboard and model screenshots in the assets folder.

[View the SQL analysis and database script](sql/Nivora_Rev_Perf_Analysis.sql)

Revenue, Store & Category Performance

The first dashboard page provides an overview of commercial performance. It covers revenue, completed orders, AOV, revenue concentration by store and category, monthly revenue movement, category sales, store cancellation rates and average delivery delays.

The dashboard reports approximately ₹15.7M in completed-order revenue, with Staples contributing about 55% of revenue and the largest store contributing about 26%.

![Revenue, Store & Category Performance](assets/Revenue%2CStore%26Category%20Performance_Nivora.png)

Customer, Retention & Operations

The second dashboard page focuses on customer behaviour, retention and operational exposure. It covers repeat revenue share, customer order depth, first-order promotion usage, repeat rates by first-order promotion status, repeat rates by first-order delivery delay, cohort retention, promotion revenue contribution and store-level customer metrics.

The dashboard reports a repeat customer rate of approximately 89.9%, with repeat customers contributing about 73.3% of total revenue. It also shows a difference in repeat rates across first-order delivery-delay groups, with the 0–10 minute group at 94.5% compared with 68.6% for customers whose first order was delayed by more than 21 minutes.

The promotion comparison shows a smaller difference. Customers whose first order used a promotion have a repeat rate of 90.3%, compared with 89.0% for customers whose first order did not use a promotion.

![Customer, Retention & Operations](assets/Customer%2C%20Retention%20%26Operations_Nivora.png)

Power BI Data Model

The Power BI model connects the transactional order data with customer, store, product, delivery and promotion information. The orders table acts as the central transaction table, with relationships to customers through customer_id, dark_stores through dark_store_id, deliveries through order_id and order_items through order_id.

The order_items table is connected to products through product_id, while promotions are connected to orders through the order_promotions mapping table. This allows the report to analyse order performance alongside customer characteristics, store performance, product categories, delivery outcomes and promotion usage.

The model also includes an Order Depth Stage table used for the customer order-depth analysis in the dashboard.

![Power BI Data Model](assets/Data%20Model_Nivora.png)

Skills Demonstrated

This project demonstrates practical SQL, PostgreSQL and Power BI skills,
including relational data modeling, synthetic data generation, data
validation, joins, aggregations, CTEs, subqueries, date functions,
window functions, DAX, KPI design, cohort analysis and business
dashboard development.

It also demonstrates the process of translating a business question into
measurable metrics, analysing the results and connecting those results
to potential business actions.

Real-World Context

The business context is informed by the operating characteristics of
India's quick-commerce sector. Swiggy's FY2024--25 Annual Report
discusses the expansion of Instamart's dark-store network and a greater
focus on utilisation, efficiency and value creation as the network
scales.

Redseer's research similarly discusses the evolution of Indian quick
commerce from rapid expansion toward questions of scale, fulfilment
efficiency and sustainable growth.

These sources are included for industry context only. They are not
sources for the Nivora dataset or its numerical findings.

References

Swiggy, Annual Report FY2024--25:
https://www.swiggy.com/corporate/wp-content/uploads/2025/07/Swiggy-Annual-Report-FY-2024-25.pdf

Redseer, Quick Commerce in India: Is Scale Expanding with Efficacy?:
https://redseer.com/digests/quick-commerce-india-scale-dark-stores-growth/

Microsoft Learn, Understand star schema and the importance for Power BI:
https://learn.microsoft.com/en-us/power-bi/guidance/star-schema

Microsoft Learn, Model relationships in Power BI Desktop:
https://learn.microsoft.com/en-us/power-bi/transform-model/desktop-relationships-understand

Project Takeaway

Nivora demonstrates an end-to-end business analytics workflow, starting
with a defined business problem and moving through data generation,
validation, SQL analysis, Power BI modeling and dashboard-based
interpretation.

The emphasis is on using data to identify where performance differs,
understanding what those differences may indicate, and recognising where
further analysis would be required before making a business decision.
