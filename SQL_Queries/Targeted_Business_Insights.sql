-- 1) What are the monthly and quarterly sales trends for Macbooks sold in North America across all years?

-- Subsection 1.1: Quarterly Sales Trends 
-- Investigating the quarterly sales dynamics of Macbooks in North America to uncover insights into purchasing behaviour and seasonal trends.

select
    extract(quarter from orders.purchase_ts) as purchase_qtr
  , count(distinct orders.id) as order_count
  , round(sum(orders.usd_price)) as total_sales
  , round(avg(orders.usd_price), 2) as aov
from
    core.orders as orders
  
left join core.customers as customers
    on orders.customer_id = customers.id
  
left join core.geo_lookup as geo_lookup
    on customers.country_code = geo_lookup.country_code

where
    lower(orders.product_name) like '%macbook%' and geo_lookup.region = 'NA' -- North America
group by
    1
order by
    1 desc, 3
;

-- Subsection 1.2: Monthly Sales Trends 
-- Probing the monthly sales variations of Macbooks in North America to understand the finer nuances of consumer demand and preferences.

select
    extract(month from orders.purchase_ts) as purchase_month
  , count(distinct orders.id) as order_count
  , round(sum(orders.usd_price)) as total_sales
  , round(avg(orders.usd_price), 2) as aov
from
    core.orders as orders
  
left join core.customers as customers
    on orders.customer_id = customers.id
  
left join core.geo_lookup as geo_lookup
    on customers.country_code = geo_lookup.country_code

where
    lower(orders.product_name) like '%macbook%' and geo_lookup.region = 'NA'
group by
    1
order by
    1 asc, 3
;



-- 2) What was the monthly refund rate for purchases made in 2020? How many refunds did we have each month in 2021 for Apple products?

-- Subsection 2.1: Monthly Refund Rate 2020
-- Scrutinising the refund rates throughout 2020 to discern any notable patterns or anomalies in product returns within the specified period.

with refund_rate as 
(
select
    date_trunc(orders.purchase_ts, month) as month
  , round((sum(case when order_status.refund_ts is not null then 1 else 0 end) / count(distinct orders.id)) * 100, 2) as refund_rate_pct
from
    core.orders as orders
  
left join core.order_status as order_status
    on orders.id = order_status.order_id

where 
    extract(year from orders.purchase_ts) = 2020
group by
    1
)

select
    refund_rate.month
  , round(avg(refund_rate.refund_rate_pct), 2) as avg_refund_rate_pct
from
    refund_rate

group by
    1
order by
    1 asc
;


-- Subsection 2.2: Monthly Apple Product Refunds in 2021
-- Analysing the occurrences of refunds for Apple products on a monthly basis in 2021 to potentially shed light on consumer satisfaction and product quality.

select
    date_trunc(orders.purchase_ts, month) as month
  , sum(case when order_status.refund_ts is not null then 1 else 0 end) as refunds
from
    core.orders as orders
  
left join core.order_status as order_status
    on orders.id = order_status.order_id

where 
    extract (year from orders.purchase_ts) = 2021
      and (lower(orders.product_name) like '%apple%' or lower(orders.product_name) like '%macbook%')
group by
    1
order by
    1
;



-- 3) Are there certain products that are getting refunded more frequently than others? What are the top 3 most frequently refunded products across all years? What are the top 3 products that have the highest count of refunds?

-- Subsection 3.1: Product Refund Frequency (Top 3)
-- Focusing on the top three products with the highest rates of refunds across multiple years, prompting questions about potential issues or discrepancies.

select
    orders.product_name
  , round((sum(case when order_status.refund_ts is not null then 1 else 0 end) / count(distinct orders.id)) * 100, 1) as refund_rate
from
    core.orders as orders
  
left join core.order_status as order_status
    on orders.id = order_status.order_id

group by
    1
order by
    2 desc
limit
    3
;


-- Subsection 3.2: Most Refunded Products
-- Identifying and exploring the products with the highest count of refunds, prompting further investigation into factors contributing to customer dissatisfaction or returns.

select
    orders.product_name
  , sum(case when order_status.refund_ts is not null then 1 else 0 end) as refunds
from
    core.orders as orders
  
left join core.order_status as order_status
    on orders.id = order_status.order_id

group by
    1
order by
    2 desc
;


-- 4) What’s the average order value across different account creation methods in the first two months of 2022? Which method had the most new customers in this time?

-- Examining the average order values across various customer acquisition methods in the initial months of 2022 to explore potential correlations between acquisition channels and purchase behaviour.

select
    customers.account_creation_method 
  , count(distinct customers.id) as num_customers  
  , round(sum(orders.usd_price) / count(distinct orders.id)) as aov
from
    core.orders as orders

left join core.customers as customers
    on orders.customer_id = customers.id

where
    extract(year from customers.created_on) = 2022
      and (extract(month from customers.created_on) = 1 or extract(month from customers.created_on) = 2)
group by
    1
order by
    2 desc
;


-- 5) What is the average time between customer registration and placing an order?

-- Investigating the average timeframes between customer registration and order placement to gain insights into the efficiency of the customer journey and identify potential areas for improvement.

select
    round(avg(date_diff(orders.purchase_ts, customers.created_on, day))) as days_to_order
from
    core.orders as orders
  
left join core.customers as customers
    on orders.customer_id = customers.id
;


-- 6) Which marketing channels perform the best in each region? Does the top channel differ across regions?

-- Exploring the effectiveness of marketing channels across different regions and questioning whether the top-performing channels vary geographically, probing into regional consumer preferences.

with regional_performance as
(
  select
    geo_lookup.region
  , customers.marketing_channel
  , count(distinct orders.id) as num_orders
  , round(sum(orders.usd_price)) as total_sales
  , round((sum(orders.usd_price) / count(distinct orders.id)), 2) as aov 
from
    core.orders as orders

left join core.customers as customers
    on orders.customer_id = customers.id

left join core.geo_lookup as geo_lookup
    on customers.country_code = geo_lookup.country_code

group by
    1, 2
order by
    1, 2
)

select
    regional_performance.region
  , regional_performance.marketing_channel
  , regional_performance.num_orders
  , regional_performance.total_sales
  , regional_performance.aov
  , row_number() over (partition by regional_performance.region order by regional_performance.num_orders desc) as rank
from
    regional_performance

where regional_performance.marketing_channel is not null
    and regional_performance.marketing_channel != 'unknown'
    and regional_performance.region is not null                 -- scrubs 7 undecipherable ouput (nulls) records
order by
    6
;

-- 7) For customers who made more than 4 orders across all years, what was the order ID, product, and purchase date of their most recent order?

-- Examining the latest orders for customers displaying high engagement levels to understand their ongoing purchasing behaviour and loyalty patterns.

select
    orders.customer_id
  , orders.id
  , orders.product_name
  , orders.purchase_ts
  , row_number() over (partition by orders.customer_id order by orders.purchase_ts) as ranking
from
    core.orders as orders

group by
    1, 2, 3, 4
qualify row_number() over (partition by orders.customer_id order by orders.purchase_ts) >= 4
order by
    1


