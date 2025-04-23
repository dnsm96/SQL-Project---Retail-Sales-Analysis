CREATE DATABASE project_sql;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

-- checking the table
select * from retail_sales;

-- Record Count
select count(*) from retail_sales;

-- Customer count
select count(distinct(customer_id)) from retail_sales;

-- Category count
select count(distinct(category)) from retail_sales;

-- what are the categories
select distinct category from retail_sales;

-- checking null values
SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

-- Deleting null values
DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

-- Data Analysis & Findings

-- Write a SQL query to retrieve all columns for sales made on '2022-11-05.
select * from retail_sales 
where sale_date = '2022-11-05';

-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select * from retail_sales 
where category = 'Clothing' and quantity >= 4 and to_char(sale_date, 'YYYY-MM') = '2022-11'

-- Write a SQL query to calculate the total sales (total_sale) for each category.
select category, sum(total_sale) as total_sale 
	from retail_sales 
	group by category 
	order by total_sale desc;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select category, round(avg(age)) average_age
	from retail_sales
	where category = 'Beauty'
	group by category;

-- Write a SQL query to find all transactions where the total_sale is greater than 1000.
select *
	from retail_sales
	where total_sale > 1000
	order by total_sale desc;

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category, gender, count(transactions_id)
	from retail_sales
	group by category, gender
	order by category;

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
with cte1 as 
	(select extract(year from sale_date) as year, to_char(sale_date, 'Month') as month, round(avg(total_sale)::numeric,2) as avg_sale
	from retail_sales
	group by year, month
	order by year),
	
cte2 as(
select year, month, avg_sale, rank() over(partition by year order by avg_sale desc)
from cte1)

select * from cte2 where rank = 1;

-- Write a SQL query to find the top 5 customers based on the highest total sales
select customer_id, sum(total_sale) as total_sale
from retail_sales
group by customer_id
order by total_sale desc
limit 5;

-- Write a SQL query to find the number of unique customers who purchased items from each category
select category, count(distinct customer_id)
from retail_sales
group by category;

-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
select shift, count(shift)
from
(select sale_time,  
case 
	when sale_time < '12:00:00' then 'Morning'
	when sale_time between '12:00:00' and '17:00:00' then 'Afternoon'
	when sale_time > '17:00:00' then 'Evening'
end as Shift
from retail_sales)
group by shift
