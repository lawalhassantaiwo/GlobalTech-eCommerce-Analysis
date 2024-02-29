# GlobalTech-eCommerce Analysis - Uncovering Data-Driven Insights


GlobalTech-eCommerce, established in 2018, is a global e-commerce platform specializing in offering the latest consumer electronics and accessories to customers worldwide. The company possesses extensive data encompassing sales, marketing, operational efficiency, product range, and loyalty initiatives. Previously overlooked, this wealth of data is now subjected to meticulous analysis to unearth key insights aimed at identifying optimization opportunities, address challenges, and offer actionable recommendations to support GlobalTech-eCommerce's growth and success in the competitive e-commerce landscape.

## Key Areas of Focus:
* **Sales Trends** - Analyzing revenue, orders placed, and average order value (AOV) trends over time.

* **Product Performance** - Evaluating the performance of different product lines and identifying
top-selling products.

* **Loyalty Program Evaluation** - Assessing the effectiveness of GlobalTech-eCommerce's loyalty program
in driving customer engagement and revenue.

* **Operational Effectiveness** - Reviewing logistics and operational efficiency to ensure seamless order
fulfillment and delivery processes.

* **Marketing Channel Effectiveness** - Analyzing the effectiveness of various marketing channels in
driving customer acquisition and revenue generation.


## Dataset Structure & Initial Checks
![ERD2](https://github.com/lawalhassantaiwo/GlobalTech-eCommerce-Analysis/assets/144157868/d04bd931-37f2-4597-b540-8edefbdcd0e4)

GlobalTech-eCommerce's dataset comprises 108,130 records from the company's ERP system, organized into five tables: orders, customers, geo_lookup, order_status, and suppliers. The analysis process involved seamlessly integrating Excel and SQL techniques to uncover key actionable insights.

Data processing, transformation, and preliminary analysis were conducted in Excel, incorporating thorough data quality operations to address inconsistencies and missing data to ensure accuracy and transparency prior to Pivot Table based analysis. These included product naming inconsistencies, missing countries, additional required columns for analysis, and null values, all meticulously documented to maintain transparency as detailed below. Subsequently, further SQL analysis was conducted to further uncover key sub-surface level insights.

* Tools used: **Excel**, **SQL**
* Steps taken to clean and prep the dataset for analysis can be found **[here](https://github.com/lawalhassantaiwo/GlobalTech-eCommerce-Analysis/blob/main/Issue%20Log%20Documentation.pdf)**.

## High-Level Insights Summary
In 2020, GlobalTech-eCommerce experienced explosive growth, but by Q1 of 2022, a sharp decline in revenue, orders, and average order value (AOV) ensued, likely due to post-COVID normalization. Annual revenue, orders placed, and AOV values dropped by **42%**, **36%**, and **9%** respectively compared to 2021. Despite this decline, analysis from 2019 to 2022 shows an average of **27K** yearly sales, generating **$7M** in revenue with an AOV of **$254**. Subsequent sections will delve into identifying additional factors potentially contributing to this decline, while also highlighting key areas of opportunity.

### Sales Performance Overview:
![Sales Performance2](https://github.com/lawalhassantaiwo/GlobalTech-eCommerce/assets/144157868/03e4f6ca-fbf6-42b2-b283-a88aeb4deec8)

* Sales trends between 2019-2022 reveal November and December as peak months, while March 2020 witnessed a surge likely triggered by the global COVID-19 outbreak. Conversely, February and October consistently showed lower sales figures, suggesting potential seasonality or external factors. In 2020, sales and revenue more than doubled compared to 2019, with sales being on average **31%** more expensive. However, despite further increase in sales in 2021, total revenue declined as items were sold at prices that were, on average, **15%** lower.

* Average Order Value (AOV) exhibited stability overall, with notable spikes observed in specific months, particularly September and October of 2022. These spikes warrant further investigation to understand the underlying factors driving the unusual increase in AOV during these months, particularly outside of the context of the effects of the COVID-19 pandemic attributable to the early 2020 spike.

### Product Performance Highlights:
![Product Mix](https://github.com/lawalhassantaiwo/GlobalTech-eCommerce/assets/144157868/960d2dc6-03a1-488f-8e56-51f0b1ab9bbe)

* Three product SKUs of the eight offered by the business (desktop monitors, Bluetooth headphones, and Mac laptops) drive **85%** of revenue and **70%** of orders, indicating strong customer demand and significant contribution to overall sales. However, there are also underperformers like the Bose SoundSport Headphones, representing less than **1%** of total orders, despite it's cheaper pricing compared to the Airpods in the same product category.

* Laptops present a mixed picture, contributing **33%** of revenue from just **6%** of orders. The company's heavy reliance on Apple products is evident, with Apple devices accounting for **50%** of revenue and **48%** of orders.

### Marketing and Sales Channel Evaluation:
![Marketing   Sales Channel Analysis](https://github.com/lawalhassantaiwo/GlobalTech-eCommerce-Analysis/assets/144157868/0a1fe6fb-d012-4387-b2f3-b67bba646095)

* The 'direct' channel consistently leads in revenue generation, contributing to **82%** of total revenue and **77%** of total orders in 2022. Conversely, the 'social media' channel lags significantly, accounting for only **1%** of total revenue and orders.
  
* It's notable that loyalty members respond twice as much to email campaigns as non-loyalty members in our major markets. This opens a clear opportunity to boost future sales through targeted email initiatives.

* Orders through the company's mobile app is significant at **17%** of all placed orders, despite contributing only **3%** to total revenue and having a much lower AOV value compared to the overall average. This indicates potential for increased sales through targeted mobile app promotion campaigns.


## Additional Insights - SQL-Based Technical Analyis
Diving deeper into our dataset with SQL, our technical analysis uncovers the following additional vital insights for GlobalTech-eCommerce to assist in future strategic business decisions for stakeholders.

SQL queries utilized to reveal the additional overarching insights are detailed in **[this section](url)**.
Additionally, specific SQL queries uncovering insights on targeted business questions are detailed in **[this section](url)**

### Evaluating  Revenue Performance by Region
* North America (NA) and Europe, Middle East, and Africa (EMEA) regions collectively accounted for **over 80%** of total revenue, highlighting their dominance in driving sales. And while a slightly lower performance was observed in 2021, a stronger 2022 upsurge to **82%**, above the previous year 80% average, indicates there are no potential shifts in consumer behavior or market dynamics expected in the near future.

### Loyalty Programme Assessment:

* Despite overall revenue and order counts being below 2019 levels, the loyalty program participants now represent the majority of both revenue (**55% up from 11%**) and order counts (**52% up from 12%**) in 2022, indicating their resilience to downward trends.

* Regarding spend, Loyalty program members now spend **$31** more per transaction than non-members, highlighting the program's effectiveness in driving higher spending. Additionally, they request refunds **3.4%** more often, suggesting their willingness to explore new product

* The 'direct' marketing channel serves as the main source for **78%** of loyalty program sign-ups for the business, highlighting its effectiveness in attracting and retaining higher value loyalty customers.

### Operational Efficiency Observations:
* Shipping and delivery times have remained consistent since 2019, (averaging **3 days** and **14 days** respectively). However, without industry benchmarks, it's unclear how these compare against industry competition.

* Interestingly, loyalty members experience the same delivery time as non-members (**14 days**), suggesting a potential area for improvement in delivery standards for higher value customers.

## Recommendations
Based on the comprehensive analysis conducted, the following recommendations are proposed for consideration by the company:

* Push towards capturing broader market segments to mitigate the risk associated with the business' heavy dependency on Apple products and allow the company to further cater to diverse customer preferences, potentially increasing sales and revenue.

* Maximize return on investment by prioritizing channels that yield the highest revenue and orders. By allocating resources more effectively, the company ensures that marketing efforts are targeted where they are most likely to generate  results.

* Increase marketing resources towards customer retention and spending drivers among loyalty members. Benefits, such as faster delivery guarantees and exclusive discounts will incentivize customer loyalty, resulting in higher spending and repeat purchases.

* Build stronger relationships with suppliers as a leverage for better pricing and terms to reduce costs and maintain healthy profit margins. Additionally, reliable suppliers ensure consistent product availability, preventing stock shortages and lost sales opportunities.




