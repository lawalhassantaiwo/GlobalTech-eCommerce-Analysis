/*
Originally conducted in Microsoft Excel for brevity, these checks provide insights into completeness, integrity, and overall characteristics. Focus remains on the core.orders table to avoid redundancy. A comprehensive overview of the dataset's cleanliness and potential issues, are provided in the accompanying data cleaning "Issue Log Documentation" file in the repository.
*/


-- 1) Visual Inspection: Examining the Initial Rows of Data
-- Reviewing a sample of 250 records to visually inspect the content and structure of the orders table.

select
    orders.customer_id
  , orders.id
  , orders.purchase_ts
  , orders.product_id
  , orders.product_name
  , orders.currency
  , orders.local_price
  , orders.usd_price
  , orders.purchase_platform
from
    core.orders as orders
limit 250
;

-- 2) Null Check: Identifying Missing Values Across Columns
-- Investigating the presence of null values in various columns to assess data completeness and integrity.

select
    sum(case when orders.customer_id is null then 1 else 0 end) as nullcount_cust_id 
  , sum(case when orders.id is null then 1 else 0 end) as nullcount_order_id
  , sum(case when orders.purchase_ts is null then 1 else 0 end) as nullcount_purchase_ts
  , sum(case when orders.product_id is null then 1 else 0 end) as nullcount_product_id
  , sum(case when orders.product_name is null then 1 else 0 end) as nullcount_product_name
  , sum(case when orders.currency is null then 1 else 0 end) as nullcount_currency
  , sum(case when orders.local_price is null then 1 else 0 end) as nullcount_local_price
  , sum(case when orders.usd_price is null then 1 else 0 end) as nullcount_usd_price
  , sum(case when orders.purchase_platform is null then 1 else 0 end) as nullcount_purchase_platform  
from
    core.orders as orders
;


-- 3) Duplicate Check: Detecting Duplicated Order IDs
-- Identifying and counting instances of duplicated order IDs to ensure data uniqueness and accuracy.

select
    orders.id
  , count(*)
from
    core.orders as orders
group by
    1
having count(*) > 1;


-- 4) Price Statistics: Analysing Product Price Distribution
-- Calculating statistical measures such as minimum, maximum, average, and standard deviation of product prices.

select
    orders.product_name
  , round(min(orders.usd_price), 2) as product_lowest_usd
  , round(avg(orders.usd_price), 2) as product_avg_usd
  , round(max(orders.usd_price), 2) as product_highest_usd
  , round(stddev(orders.usd_price), 2) as product_std_dev_usd
from
    core.orders as orders
group by
    1
;


-- 5) Purchase Date Range: Determining the Temporal Scope of Data
-- Finding the earliest and latest purchase dates to establish the timeframe covered by the dataset.

select
    min(orders.purchase_ts) as earliest_date
  , max(orders.purchase_ts) as latest_date
from
    core.orders as orders
;


-- 6) Product Order Counts: Counting Orders per Product
-- Determining the number of orders placed for each product to understand popularity and demand.

select
    orders.product_name
  , count(*) product_order_count
from
    core.orders as orders
group by
    1
order by
    2 desc
;
