-- SQL Scripts for General Performance Analysis


-- Section 1: Annual Sales Analysis
-- This section provides an overview of annual sales performance, including metrics such as total revenue, average order value (AOV), total transactions, and their respective year-on-year growth rates, offering insights into the company's revenue changes year on year.

with yearly_summary as 
(
  select
      extract(year from orders.purchase_ts) as year
    , sum(orders.usd_price) as total_sales
    , avg(orders.usd_price) as aov
    , count(orders.id) as total_orders
  from
    core.orders as orders
  group by
  1
)

select
    year
  , round(total_sales, 2) as total_sales
  , round(aov, 2) as aov
  , total_orders
  , round((total_sales / lag(total_sales) over (order by year) - 1) * 100, 2) as sales_yearly_growth_pct
  , round((aov / lag(aov) over (order by year) - 1) * 100, 2) as aov_yearly_growth_pct
  , round((total_orders / lag(total_orders) over (order by year) - 1) * 100, 2) as orders_yearly_growth_pct
from
    yearly_summary
order by 1
;


-- Section 2: Quarterly Sales Overview
-- Here, we delve into quarterly sales performance, analysing metrics such as total sales, AOV, total transactions, and their quarterly growth rates, uncovering patterns and fluctuations in revenue on a three-month basis.

with quarterly_summary as 
(
  select
    date_trunc(orders.purchase_ts, quarter) as quarter,
    extract(year from orders.purchase_ts) as year,
    sum(orders.usd_price) as total_sales,
    avg(orders.usd_price) as aov,
    count(orders.id) as total_orders
  from 
      core.orders as orders
  group by
  1, 2
)

select
    quarterly_summary.year as year
  , quarterly_summary.quarter as quarter
  , round(quarterly_summary.total_sales, 2) as total_sales
  , round(quarterly_summary.aov, 2) as aov
  , quarterly_summary.total_orders as total_orders
  , round((quarterly_summary.total_sales / lag(quarterly_summary.total_sales) over (order by quarterly_summary.quarter) - 1) * 100, 2) as sales_quarterly_growth_pct
  , round((quarterly_summary.aov / lag(quarterly_summary.aov) over (order by quarterly_summary.quarter) - 1) * 100, 2) as aov_quarterly_growth_pct
  , round((quarterly_summary.total_orders / lag(quarterly_summary.total_orders) over (order by quarterly_summary.quarter) - 1) * 100, 2) as orders_quarterly_growth_pct
  , round(sum(quarterly_summary.total_sales) over (partition by year order by quarterly_summary.quarter), 2) as cumulative_sales_by_year
from 
    quarterly_summary
order by
1, 2
;


-- Section 3: Monthly Revenue Insights
-- Delving into granular details, this section examines month-on-month revenue trends, considering metrics such as total sales, AOV, and total transactions, highlighting any seasonal variations or emerging patterns.

with monthly_summary as
(
  select
      date_trunc(orders.purchase_ts, month) as month
    , extract(year from orders.purchase_ts) as year
    , sum(orders.usd_price) as total_sales
    , avg(orders.usd_price) as aov
    , count(orders.id) as total_orders
  from core.orders as orders
  group by
  1, 2
)

select
    monthly_summary.month
  , round(monthly_summary.total_sales, 2) as total_sales
  , round(monthly_summary.aov, 2) as aov
  , monthly_summary.total_orders as total_orders
  , round((monthly_summary.total_sales / lag(monthly_summary.total_sales) over (order by monthly_summary.month) - 1) * 100, 2) as sales_monthly_growth_pct
  , round((monthly_summary.aov / lag(monthly_summary.aov) over (order by monthly_summary.month) - 1) * 100, 2) as aov_monthly_growth_pct
  , round((monthly_summary.total_orders / lag(monthly_summary.total_orders) over (order by monthly_summary.month) - 1) * 100, 2) as orders_monthly_growth_pct
  , round(sum(monthly_summary.total_sales) over (partition by year order by monthly_summary.month), 2) as cumulative_sales_by_year
from 
    monthly_summary
order by
1
;


-- Section 4: Regional Sales Trends Analysis
-- Geographical analysis reveals how sales vary across regions annually, considering metrics such as total revenue, AOV, total transactions, and their yearly growth rates, shedding light on regional preferences and market dynamics.

with yearly_regional_summary as
(
  select
      extract(year from orders.purchase_ts) as year
    , geo_lookup.region
    , sum(orders.usd_price) as total_sales
    , avg(orders.usd_price) as aov
    , count(orders.id) as total_orders
  from      core.orders as orders
  
  left join core.customers as customers
         on orders.customer_id = customers.id

  left join core.geo_lookup as geo_lookup
         on customers.country_code = geo_lookup.country_code
  
  where geo_lookup.region is not null -- scrubs 4 undecipherable output records
  group by
  1, 2
),

total_annual_sales as (
  select
      year
    , sum(total_sales) as total_annual_sales
  from 
      yearly_regional_summary as yrs
  group by
  1
)

select
    yrs.year
  , yrs.region
  , round(yrs.total_sales) as total_sales
  , round(yrs.aov) as aov
  , yrs.total_orders
  , round((yrs.total_sales / lag(yrs.total_sales) over (partition by yrs.region order by yrs.year) - 1) * 100, 2) as regional_sales_yearly_growth_pct
  , round((yrs.aov / lag(yrs.aov) over (partition by yrs.region order by yrs.year) - 1) * 100, 2) as regional_aov_yearly_growth_pct
  , round((yrs.total_orders / lag(yrs.total_orders) over (partition by yrs.region order by yrs.year) - 1) * 100, 2) as regional_orders_yearly_growth_pct
  , round((yrs.total_sales / tas.total_annual_sales) * 100, 2) as regional_revenue_percentage
from 
      yearly_regional_summary as yrs

inner join  total_annual_sales as tas
  on  yrs.year = tas.year

order by
1, 2
;


-- Section 5: Rolling 12-Month Performance
-- By tracking sales over a rolling 12-month period, this section offers insights into revenue trends, capturing short-term fluctuations with metrics such as total sales, providing a dynamic perspective on performance.

with monthly_sales as 
(
  select
    date_trunc(orders.purchase_ts, month) as month
  , round(sum(orders.usd_price), 2) as total_sales
  from 
      core.orders as orders
  group by
  1
),

rolling_twelve_month_sales as 
(
  select
    monthly_sales.month
  , monthly_sales.total_sales
  , sum(monthly_sales.total_sales) over (order by monthly_sales.month rows between 11 preceding and current row) as rolling_twelve_months
  from monthly_sales
)

select
    rtms.month
  , rtms.total_sales
  , rtms.rolling_twelve_months
  , rtms.rolling_twelve_months - lag(rtms.rolling_twelve_months, 1) over (order by rtms.month) as rolling_twelve_months_diff
  , round(((rtms.rolling_twelve_months - lag(rtms.rolling_twelve_months, 1) over (order by rtms.month)) / lag(rtms.rolling_twelve_months, 1) over (order by rtms.month)) * 100, 2) as rolling_twelve_months_pct_diff
from 
    rolling_twelve_month_sales as rtms
order by
1
;


-- Section 6: Product Sales Breakdown
-- Focusing on product-level analysis, this section examines how individual items contribute to overall sales performance over the year, considering metrics such as total revenue, AOV, total transactions, and their respective year-on-year growth rates.

with yearly_product_summary as
(
  select
      extract(year from orders.purchase_ts) as year
    , product_name
    , sum(orders.usd_price) as total_sales
    , avg(orders.usd_price) as aov
    , count(orders.id) as total_orders
  from
      core.orders as orders
  group by
  1, 2
),

total_product_sales as 
(
  select
      year
    , sum(yps.total_sales) as total_annual_sales
    , sum(yps.total_orders) as total_annual_orders 
  from
       yearly_product_summary as yps
  group by
  1
)

select
    yps.year
  , yps.product_name
  , round(yps.total_sales) as total_sales
  , round(yps.aov, 2) as aov
  , yps.total_orders
  , round((yps.total_sales / lag(yps.total_sales) over (partition by yps.product_name order by yps.year) - 1) * 100, 2) as product_sales_yearly_growth_pct
  , round((yps.aov / lag(yps.aov) over (partition by yps.product_name order by yps.year) - 1) * 100, 2) as product_aov_yearly_growth_pct
  , round((yps.total_orders / lag(yps.total_orders) over (partition by yps.product_name order by yps.year) - 1) * 100, 2) as product_orders_yearly_growth_pct
  , round((yps.total_sales / tps.total_annual_sales) * 100, 2) as product_revenue_pct
  , round((yps.total_orders / tps.total_annual_orders) * 100, 2) as product_orders_pct 
from
      yearly_product_summary as yps

join
      total_product_sales as tps
  on  yps.year = tps.year

order by
  1, 2
;


-- Section 7: Loyalty Programme Impact Assessment
-- Evaluating the efficacy of loyalty programmes, this section assesses their impact on customer spending habits and overall sales revenue, considering metrics such as total revenue, AOV, total transactions, and their yearly growth rates.

with year_loyalty_sales as 
(
  select
      extract(year from orders.purchase_ts) as year
    , customers.loyalty_program
    , sum(orders.usd_price) as total_sales
    , avg(orders.usd_price) as aov
    , count(orders.id) as total_orders
  from
      core.orders as orders
  
  left join core.customers as customers
         on  orders.customer_id = customers.id
      
  group by  1, 2
  
  having customers.loyalty_program = 1
),

year_total_sales as 
(
  select
      extract(year from orders.purchase_ts) as year
    , sum(orders.usd_price) as total_sales_in_year
    , count(orders.id) as total_orders_in_year
  from 
      core.orders as orders
  group by
  1
)

select
    yls.year
  , yls.loyalty_program
  , round(yls.total_sales) as total_sales
  , round(yls.aov, 2) as aov
  , yls.total_orders
  , round(yls.total_sales / yts.total_sales_in_year, 2) as revenue_split
  , round(yls.total_orders / yts.total_orders_in_year, 2) as orders_split
  , round((yls.total_sales - lag(yls.total_sales) over (partition by yls.loyalty_program order by yls.year)) / lag(yls.total_sales) over (partition by yls.loyalty_program order by yls.year) * 100, 2) as annual_revenue_pct_change
  , round((yls.aov - lag(yls.aov) over (partition by yls.loyalty_program order by yls.year)) / lag(yls.aov) over (partition by yls.loyalty_program order by yls.year) * 100, 2) as annual_aov_pct_change
  , round((yls.total_orders - lag(yls.total_orders) over (partition by yls.loyalty_program order by yls.year)) / lag(yls.total_orders) over (partition by yls.loyalty_program order by yls.year) * 100, 2) as annual_orders_pct_change
from 
      year_loyalty_sales as yls

join  year_total_sales as yts
  on  yls.year = yts.year

order by
1, 2
;


-- Section 8: Marketing Channel Effectiveness Evaluation
-- Analysing the effectiveness of various marketing channels, this section explores their contributions to overall sales and customer acquisition, considering metrics such as total revenue, AOV, total transactions, and their year-on-year growth rates.

with yearly_marketing_summary as 
(
  select
      extract(year from orders.purchase_ts) as year
    , customers.marketing_channel
    , sum(orders.usd_price) as total_sales
    , avg(orders.usd_price) as aov
    , count(orders.id) as total_orders
  from 
            core.orders as orders
  
  left join core.customers as customers
         on   orders.customer_id = customers.id        

  group by
  1, 2
),

total_annual_sales as 
(
  select
      year
    , sum(total_sales) as total_annual_sales
  from 
      yearly_marketing_summary
  group by
  1
)

select
    yms.year
  , yms.marketing_channel
  , round(yms.total_sales) as total_sales
  , round(yms.aov, 2) as aov
  , yms.total_orders
  , round((yms.total_sales / lag(yms.total_sales) over (partition by yms.marketing_channel order by yms.year) - 1) * 100, 2) as sales_yearly_growth_pct
  , round((yms.aov / lag(yms.aov) over (partition by yms.marketing_channel order by yms.year) - 1) * 100, 2) as aov_yearly_growth_pct
  , round((yms.total_orders / lag(yms.total_orders) over (partition by yms.marketing_channel order by yms.year) - 1) * 100, 2) as orders_yearly_growth_pct
  , round((yms.total_sales / tas.total_annual_sales) * 100, 2) as marketing_channel_revenue_percentage
from 
      yearly_marketing_summary as yms

join  total_annual_sales as tas on
      yms.year = tas.year

order by
1, 2
;


-- Section 9: Regional Delivery and Shipping Efficiency
-- This section evaluates the efficiency of delivery and shipping processes across different regions, considering metrics such as average times from purchase to shipping, shipping to delivery, and total purchase to delivery, along with their yearly changes.

with regional_avg_delivery as 
(
    select
        geo_lookup.region
      , extract(year from order_status.purchase_ts) as year
      , round(avg(date_diff(order_status.ship_ts, order_status.purchase_ts, day)), 2) as avg_purchase_to_ship_days
      , round(avg(date_diff(order_status.delivery_ts, order_status.ship_ts, day)), 2) as avg_ship_to_delivery_days
      , round(avg(date_diff(order_status.delivery_ts, order_status.purchase_ts, day)), 2) as avg_purchase_to_delivery_days
    from
              core.orders as orders
    
    left join core.order_status as order_status
        on orders.id = order_status.order_id
    
    left join core.customers as customers
        on orders.customer_id = customers.id
    
    left join core.geo_lookup as geo_lookup
        on customers.country_code = geo_lookup.country_code
    
    where 
        geo_lookup.region is not null and order_status.purchase_ts is not null -- scrubs 6 undecipherable output records
    group by
    1, 2
)

select
    rad.region
  , rad.year
  , rad.avg_purchase_to_ship_days
  , rad.avg_ship_to_delivery_days
  , rad.avg_purchase_to_delivery_days
  , round((rad.avg_purchase_to_delivery_days - lag(rad.avg_purchase_to_delivery_days) over (partition by rad.region order by rad.year)) / lag(rad.avg_purchase_to_delivery_days) over (partition by rad.region order by rad.year) * 100, 2) as pct_change_purchase_to_delivery
from 
    regional_avg_delivery as rad
order by
1 desc
;


-- Section 10: Regional Product Refund Analysis
-- Exploring refund rates across different regions, this section identifies potential issues in product satisfaction or quality, considering metrics such as refund rates, impacting customer retention and brand reputation.

select
    geo_lookup.region
  , extract(year from order_status.purchase_ts) as year
  , orders.product_name
  , round((sum(case when order_status.refund_ts is not null then 1 else 0 end) / count(distinct orders.id)) * 100, 2) as refund_rate
from
    core.orders as orders

left join core.order_status as order_status
    on orders.id = order_status.order_id

left join core.customers as customers
    on orders.customer_id = customers.id

left join core.geo_lookup as geo_lookup
    on customers.country_code = geo_lookup.country_code

where
     geo_lookup.region is not null and order_status.purchase_ts is not null -- scrubs 17 undecipherable records
group by
1, 2, 3
order by
2, 3
