//*creating table
create table retail_analysis
(transactions_id int primary key,
sale_date date,sale_time time,customer_id int,gender varchar(15),age int,category varchar(15),quantity int,
price_per_unit float,cogs float,total_sale float
);
select*from retail_analysis;

select count(*) from retail_analysis;

select*from retail_analysis where transactions_id is null;

-- Data Exploration

-- How many sales we have?
select count(*) as total_sale from retail_analysis;

-- How many uniuque customers we have ?
select count(distinct customer_id) as total_customers from retail_analysis;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select*from retail_analysis where sale_date ='2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022.
select * from retail_analysis where 
category = 'Clothing'
and
to_char(sale_date,'YYYY-MM')='2022-11' and quantiy >= 4;
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category,sum(total_sale), count(*) as total_orders from retail_analysis group by 1;
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select round(avg(age),2) as avg_age from retail_analysis where category = 'Beauty';
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_analysis where total_sale >=1000;
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select count(transactions_id) as transaction_id,gender,category from retail_analysis group by 2,3 order by 1;
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select year,month,total_sale
from 
(
select
extract(month from sale_date)as month ,
extract(year from sale_date)as year,
avg(total_sale) as total_sale,
rank() over(partition by extract (year from sale_date)order by avg(total_sale)desc) as rank
from retail_analysis group by 1,2
) as t1
where rank=1;
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.
select customer_id,sum(total_sale) as total_sales from retail_analysis
group by 1
order by 2 desc;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category,count(distinct customer_id) as cnt_unique from retail_analysis
group by 1;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
select *,
 case
     when extract(hour from sale_time)<12 then 'morning'
     when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
	 else 'evening'
end as shift
from retail_analysis
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;
	 







