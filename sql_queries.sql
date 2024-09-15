-- SQL Retail Sales Analysis

-- 1. Database Setup
CREATE DATABASE sql_project_1;


-- Create table 
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


select * from retail_sales;

-- 2. Data Exploration & Cleaning

-- Determine the total number of records in the dataset.
SELECT COUNT(*) as Record_Count FROM retail_sales;

-- Find out how many unique customers are in the dataset.
SELECT COUNT(DISTINCT customer_id) as Customer_Count FROM retail_sales;

-- Identify all unique product categories in the dataset.
SELECT DISTINCT category as product_categories FROM retail_sales;


-- Check for any null values in the dataset and delete records with missing data.
SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL OR total_sale IS NULL;


DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;



-- 3. Data Analysis & Findings

-- Write a SQL query to retrieve all columns for sales made on '2022-11-05':
SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';

-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is 4 in the month of Nov-2022:
SELECT * FROM retail_sales WHERE category = 'Clothing' AND quantity = 4 AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';

-- Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT category, SUM(total_sale) AS total_sales, COUNT(*) as total_orders FROM retail_sales GROUP BY category;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT ROUND(AVG(age), 2) as avg_age from retail_sales where category = 'Beauty'

-- Write a SQL query to find all transactions where the total_sale is greater than 1000.:
select * from retail_sales where total_sale>1000

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
select count(transactions_id), gender, category 
from retail_sales
group by category, gender

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
select year, month, avg_sale
from (SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2) as t1
where t1.rank = 1

-- Write a SQL query to find the top 5 customers based on the highest total sales
select distinct customer_id, sum(total_sale) as total_sales
from retail_sales 
group by 1
order by 2 desc
limit 5

-- Write a SQL query to find the number of unique customers who purchased items from each category.
select category, count(distinct customer_id)
from retail_sales
group by category



-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)

select shift, count(*)
from hourly_sale
group by shift



