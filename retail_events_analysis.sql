/** Question 1. Provide a list of products with a base price greater than 500 and that are feautred in promo type of 'BOGOF' (Buy one geet one free).**/

Select distinct dim_products.product_name,dim_products.category,fact_events.base_price from retail_db.dim_products
inner join retail_db.fact_events on dim_products.product_code=fact_events.product_code 
where fact_events.base_price>500 and fact_events.promo_type="BOGOF";

/* This informtion will help us identify high-value products that are currently being heavily discounted, 
which cab be useful for evaluating our pricing and promotion Startegies.*/

Select distinct dim_products.product_name,dim_products.category,fact_events.promo_type,fact_events.base_price from retail_db.dim_products
inner join retail_db.fact_events on dim_products.product_code=fact_events.product_code 
where fact_events.base_price>500;

/* The above query retrives the price greater than 500 for all the products, which helps to know about the items heavily discounted.*/

/** Question 2. Generate a report that provides a overview of the number of the stores in each city.**/

select dim_stores.city, count(store_id) as store_count from retail_db.dim_stores
group by dim_stores.city 
order by store_count desc;

/* This information helps to us know about the store presence in each city, which will assist in optimizing our retail operations.*/

/** Question 3. Generate a report that displays each campaign along with the total revenue generated before and after the campaign? **/

select dim_campaigns.campaign_name, 
sum(fact_events.quantity_sold_before_promo*fact_events.base_price/1000000) as total_revenue_before_promo, 
sum(fact_events.quantity_sold_after_promo*fact_events.base_price/1000000) as total_revenue_after_promo
from retail_db.dim_campaigns
inner join retail_db.fact_events on dim_campaigns.campaign_id=fact_events.campaign_id
group by dim_campaigns.campaign_name;

/* This report helps us in evaluating the financial impact of our promotional campaigns.*/

/** Question 4. Generate a reoport thar shows incremental sold quatintiy(ISU%) for each category during the diwali campaign.
Additionally provide ranking on the ISU%.**/

select dim_campaigns.campaign_name,dim_products.category, (sum(fact_events.quantity_sold_after_promo) - sum(fact_events.quantity_sold_before_promo))/sum(fact_events.quantity_sold_before_promo)*100
as ISU_Percentage,
RANK() OVER (ORDER BY (sum(fact_events.quantity_sold_after_promo) - sum(fact_events.quantity_sold_before_promo))/sum(fact_events.quantity_sold_before_promo)*100 DESC) AS Rank_category
from retail_db.dim_products 
inner join retail_db.fact_events on dim_products.product_code=fact_events.product_code
INNER JOIN 
    retail_db.dim_campaigns ON dim_campaigns.campaign_id = fact_events.campaign_id
where dim_campaigns.campaign_name="Diwali"
group by dim_products.category;

/* This information helps us in evaluating the catergory wise success and imapct of diwali campigns on sales.*/

/** Question 5. Create a report featuring the Top 5 products, ranked by Incremental Revenue Percentage(IR%), across all campaigns.**/

select dim_products.product_name, dim_products.category, 
(sum(fact_events.quantity_sold_after_promo*fact_events.base_price) - sum(fact_events.quantity_sold_before_promo*fact_events.base_price))/sum(fact_events.quantity_sold_before_promo*fact_events.base_price)*100
as IR_Percentage,
rank() over (order by (sum(fact_events.quantity_sold_after_promo*fact_events.base_price) - sum(fact_events.quantity_sold_before_promo*fact_events.base_price))/sum(fact_events.quantity_sold_before_promo*fact_events.base_price)*100 desc) as Rank_IR
from retail_db.dim_products
inner join retail_db.fact_events on dim_products.product_code=fact_events.product_code
group by dim_products.category,dim_products.product_name;

/*This analysis helps in identifying the most succesfull products in terms of incremental revenue across our campaigns, assisting in product optimization.*/






