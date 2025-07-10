--- SQL RETAIL SALE ANALYSIS ---

CREATE TABLE retail_sales
			(
				transactions_id INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id INT,
				gender CHAR(5),
				age INT,
				category VARCHAR(15),
				quantiy INT,
				price_per_unit INT,
				cogs FLOAT,
				total_sale FLOAT
			);

---- DATA CLEANING --->>

-- COUNT THE RECORDS 
SELECT COUNT(*) FROM retail_sales;

-- CHANGED TYPE CHAR TO VARCHAR OF GENDER COLUMN
ALTER TABLE retail_sales
ALTER COLUMN gender TYPE VARCHAR(15);

-- RENAMED THE COLUM NAME 
ALTER TABLE retail_sales RENAME COLUMN quantiy TO quantity;

-- SELECT THE RECORD TO ANALYSE
SELECT * FROM retail_sales
LIMIT 5;

-- CHECKING FOR NULL VALUES
SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR 
	category IS NULL
	OR
	quantity IS NULL
	OR 
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR 
	total_sale IS NULL ;

-- DELETING THE NULL VALUE RECORDS IN DATA 
DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR 
	category IS NULL
	OR
	quantity IS NULL
	OR 
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR 
	total_sale IS NULL ;

-- CHECK NULL VALUES FOR AGE COLUMN
SELECT * FROM retail_sales
WHERE
	age IS NULL;

-- REPLACING THE AGE NULL VALUE WITH AVERAGE OF AGES
WITH mean_age AS(
	SELECT AVG(age) AS avg_age
	FROM retail_sales 
	WHERE age IS NOT NULL
) 
UPDATE retail_sales
SET age = ROUND((SELECT avg_age FROM mean_age))::INT
WHERE age IS NULL;

-- LETS CHECK THE REMAINING COUNT OF RECORDS REMAINING
SELECT COUNT(*) FROM retail_sales;



--- DATA EXPLORATION --->>

SELECT * FROM retail_sales LIMIT 2;

-- 1. How many total sales we have
SELECT COUNT(*) AS total_sale FROM retail_sales;

-- 2. How many unique customers we have
SELECT COUNT(DISTINCT(customer_id)) FROM retail_sales;

-- 3. How many categories we have
SELECT DISTINCT(category) AS product_category FROM retail_sales;


--- DATA ANALYSIS --->>

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


--  Q1. Write a query to retrive all columns for the sales made on '2022-11-05'
SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';

-- Q2. Write a query to retrive all transactions where the category is 'Clothing' and 
-- the quantity sold is more than 3 in the month of NOV-2022
SELECT 
	*
FROM retail_sales
WHERE 
	category = 'Clothing'
	AND
	quantity > 3
	AND 
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
	category,
	SUM(total_sale) AS Net_Sale,
	COUNT(*) AS Total_Orders
FROM retail_sales
GROUP BY 1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
	ROUND(AVG(age),2) AS Customer_avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by 
-- each gender in each category.
SELECT 
	category,
	gender,
	COUNT(transactions_id) AS Total_transactions
FROM retail_sales
GROUP BY 
	category,
	gender
ORDER BY 
	category;

-- Q.7 Write a SQL query to calculate the average sale for each month. 
-- Find out best selling month in each year
SELECT 
	year,
	month,
	avg_sale
FROM
	(
		SELECT
			EXTRACT(YEAR FROM sale_date) AS year,
			EXTRACT(MONTH FROM sale_date) AS month,
			ROUND(AVG(total_sale)) AS avg_sale,
			RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY ROUND(AVG(total_sale)) DESC) AS best_sell 
		FROM retail_sales
		GROUP BY 1,2
	) AS T1
WHERE BEST_SELL =1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select * from retail_sales;
SELECT
	customer_id,
	SUM(total_sale) max_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY max_sale DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
	category,
	COUNT(DISTINCT customer_id)
FROM retail_sales
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders 
-- (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH 
hourly_sale 
AS
(
	SELECT *,
		CASE
			WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
			WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END AS shift
	FROM retail_sales
 )
SELECT
	shift,
	COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;

--- END OF PROJECT --- 


	




	
	



	




	
	
	



