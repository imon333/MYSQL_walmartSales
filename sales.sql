-- Create database
CREATE DATABASE IF NOT EXISTS walmartSales;


-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);


-- Data cleaning
SELECT
	*
FROM sales;


-- Add the time_of_day column
-- ------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------Feature Engineering --------------------------------------------------


-- time_of_day

SELECT
time,
(
CASE
	WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
    WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
    ELSE "Evening"
END) AS time_of_date
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);
UPDATE sales
SET time_of_day =(
	CASE
		WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
		ELSE "Evening"
	END
);

-- day_name

SELECT 
date,
DAYNAME(DATE) AS day_name
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);
UPDATE sales
SET day_name = DAYNAME(DATE);

-- month_name
SELECT
date,
MONTHNAME(date) AS month_name
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(12);
UPDATE sales
SET month_name = monthname(DATE);

-- -------------------------------------------------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------Generic --------------------------------------------------
-- How many unique cities does the data have ?
SELECT
		DISTINCT city
FROM sales;
-- How many Branch ?

SELECT
		DISTINCT branch
FROM sales;

SELECT 
   DISTINCT city,
   branch
FROM sales;
 
-- -------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------Product----------------------------------------------------------
-- How many unique product lines does the data have?
SELECT
	DISTINCT product_line
FROM sales;

-- how many different payment method
SELECT
	payment_method,
    count(payment_method) as count
FROM sales
GROUP BY payment_method
ORDER BY count DESC;
-- What is the most selling product line ?

SELECT
	product_line,
    count(product_line) as count
FROM sales
GROUP BY product_line
ORDER BY count DESC;

-- what is the total revenue in month?
SELECT
	month_name AS month,
    SUM(total) as total_revenue
    FROM sales
    GROUP BY month_name
    ORDER BY total_revenue DESC;
    
-- what month had the largest COGS?

SELECT 
	month_name AS month,
    SUM(cogs) AS cogs
FROM sales
GROUP BY month_name
ORDER BY cogs DESC;

-- what product line had the largest revenue?

SELECT
	product_line,
    SUM(total) AS total_revenue
FROM sales
Group BY product_line
Order by total_revenue DESC;


-- what city has with the largest revenue?
SELECT
	city,
    branch,
    SUM(total) AS total_revenue
FROM sales
Group BY city,branch
Order by total_revenue DESC;

-- what product line had the alrgest VAT?
SELECT 
	product_line,
    AVG(VAT) AS avg_tax
    FROM sales
    group by product_line
    order by avg_tax DESC;
    
-- which branch sold more products than average product sold?
SELECT
	branch,
    SUM(quantity) AS qty
FROM sales
GROUP by branch
HAVING SUM(quantity) > (SELECT AVG (quantity) from sales);

-- what is the most common product line by gender?

SELECT
	gender,
	product_line,
	COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- what is the average rating of each product line ?

SELECT
	ROUND(AVG(rating),2) AS avg_rating,
    product_line
From sales
group by product_line
order by avg_rating DESC;

-- ---------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------  Sales    ----------------------------------------------------------

-- Number of sales made in each time of the day. per weekday 
Select 
	time_of_day,
    count(*) As total_sales
from sales
Where day_name = "sunday"
Group by time_of_day
ORDER BY total_sales DESC;

-- which types bring more revinue?
SELECT 
	customer_type,
    SUM(total) as total_rev
from sales
GROUP BY customer_type
ORDER BY total_rev DESC;

-- Which city has the largest tax. percent / VAT (calue added TAx)?

SELECT
	city,
    AVG(VAT) AS VAT
from sales
group by city
order by VAT desc;

-- which customer type pays the most in VAT ?
    SELECT
	customer_type,
    AVG(VAT) AS VAT
from sales
group by customer_type
order by VAT desc;

  -- ---------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------  Customers    ---------------------------------------------------------- 
-- How many unique customer types does the data have?
SELECT 
	DISTINCT customer_type
FROM sales;

-- How many unique payment method does the data have?
SELECT 
	DISTINCT payment_method
FROM sales;

-- which customer type buys the most?
SELECT 
	customer_type,
    COUNT(*) AS cstm_cnt
FROM sales
Group by customer_type;

-- What is the gender of most od the customers?
SELECT
	gender,
    count(*) as gender_cnt
FROM sales
Group by gender
order by gender_cnt desc;

-- what is the gender distribution per branch ?

SELECT
	gender,
    count(*) as gender_cnt
FROM sales
where branch = "A"
Group by gender
order by gender_cnt desc;

-- Which time of the day do cutomers give most ratings?
Select
	time_of_day,
    AVG(rating) as avg_rating
From sales
Group BY time_of_day
Order by avg_rating desc;

-- Which time of the day do customers give most rating per branch?
Select
	time_of_day,
    AVG(rating) as avg_rating
From sales
Where branch ="b"
Group BY time_of_day
Order by avg_rating desc;

-- Which day of the week the best ratings?

SELECT
	day_name,
    AVG(RATING) as avg_rating
    
from sales
GROUP BY day_name
ORDER BY avg_rating desc;

-- which day of the week has the most best average ratings per branch?
SELECT
	day_name,
    AVG(RATING) as avg_rating
    
from sales
where branch = "c"
GROUP BY day_name
ORDER BY avg_rating desc;

    