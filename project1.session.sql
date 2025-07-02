--Creating Database 
CREATE DATABASE project1



-- Creating Table

DROP TABLE SALES
CREATE TABLE SALES
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

SELECT COUNT(*) FROM SALES

--Importing Data 
COPY SALES 
FROM 'C:\SQL\sql_load\SQL - Retail Sales Analysis_utf .csv'
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',', QUOTE '"',ENCODING 'UTF-8');

-- Finding NULL VALUES 
SELECT *  FROM sales
WHERE
       transactions_id is NULL
OR     sale_date is NULL
OR     sale_time is NULL
OR     customer_id is NULL
OR     gender is NULL
OR     age is NULL
OR     category is NULL
OR     quantity is NULL
OR     price_per_unit is NULL
OR     cogs is NULL 
OR     total_sale is NULL;

--DATA Cleaning && Data Exploration

DELETE FROM sales
WHERE
       transactions_id is NULL
OR     sale_date is NULL
OR     sale_time is NULL
OR     customer_id is NULL
OR     gender is NULL
OR     age is NULL
OR     category is NULL
OR     quantity is NULL
OR     price_per_unit is NULL
OR     cogs is NULL 
OR     total_sale is NULL;

--total number of sales?
SELECT COUNT(*) AS total_sales from sales;

--how many unique customers we have?   
SELECT COUNT(DISTINCT(customer_id)) as unique_customers from sales;

--types of category we have?
SELECT DISTINCT(category) as category_types from sales ;

--average sale in each transaction?
SELECT AVG(price_per_unit * quantity) as average_sale from sales;

--total revenue  generated?
SELECT SUM(price_per_unit*quantity) as total_revenue from sales;

--average sales per category? 
SELECT
category, 
AVG(price_per_unit*quantity) as average_sales From sales
GROUP BY 
category
ORDER BY 
average_sales DESC;

--total sales categorywise?
SELECT
category,
SUM(price_per_unit * quantity) as categorywise_sales from sales
GROUP BY
category
ORDER BY
categorywise_sales ASC;

--total repeat buyers?
SELECT
customer_id,
count(customer_id) as total_times_bought
from sales
GROUP BY
customer_id
HAVING
COUNT(customer_id)>1
ORDER BY 
total_times_bought DESC

--which month has the highest sales
SELECT SUM(quantity*price_per_unit) as sale,
EXTRACT(month from sale_date) as month
FROM sales
GROUP BY MONTH
ORDER BY
sale desc


--DATA ANALYSIS AND BUSINESS INSIGHTS

--1.**Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
SELECT *
FROM sales
WHERE sale_date = '2022-11-05';

    
--2.**Write a SQL query to retrieve all transactions where the category 
--is 'Clothing' and the quantity sold is more than 2 in the month of Nov-2022**:

SELECT *
        From
        sales
WHERE
    category = 'Clothing' 
    AND  quantity > 2
    AND  sale_date >= '2022-11-01'
    AND  sale_date < '2022-12-01';

SELECT 
  *
FROM sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category,
SUM(price_per_unit*quantity) as saledone, 
COUNT(category) as totalorders
from sales
GROUP BY 1;

-- Q.4 Write a SQL query to find the average age of 
--customers who purchased items from the 'Beauty' category.

SELECT 
    ROUND(AVG(age),3) as avg_a
From 
    sales
Where
    category = 'Beauty';


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT 
    *
FROM
    sales
WHERE   
    total_sale > 1000;   

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) 
--made by each gender in each category.     

SELECT 
    category,
    gender,
COUNT(*)
FROM 
    sales
GROUP BY
    category,
    gender
ORDER BY
    category,
    gender 

-- Q.7 Write a SQL query to calculate the average sale for each month. 
--Find out best selling month in each year.

SELECT 
    EXTRACT(Year from sale_date) as year,
    EXTRACT(Month from sale_date) as month,
    AVG(quantity*price_per_unit) as salee
FROM
    sales
GROUP BY
    1,2
ORDER BY
    1,salee desc

--or

--SUBQUERY USED

SELECT 
    year,
    month,
    salee
FROM(
SELECT 
    EXTRACT(Year from sale_date) as year,
    EXTRACT(Month from sale_date) as month,
    AVG(total_sale) as salee,
    RANK() OVER (PARTITION BY EXTRACT(Year from sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM
    sales
GROUP BY
    1,2
) as T1
WHERE rank = 1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT
    customer_id,
    SUM(total_sale) 
FROM
    sales
GROUP BY
    1
ORDER BY
    2 DESC
LIMIT 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT
    COUNT(DISTINCT(customer_id)) as unique_customers,
    category
FROM
    sales
GROUP BY 
    2




-- Q.10 Write a SQL query to create each shift and number of orders 
--(Example Morning <12, Afternoon Between 12 & 17, Evening >17)

--Common Table Expression(CTE) used 

WITH
    hourly_sale
    AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'MORNING'
        WHEN EXTRACT(HOUR from sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
        ELSE 'EVENING'
    END AS 
        shift
FROM
    sales
)
SELECT
    shift,
    COUNT(*)
FROM
    hourly_sale
GROUP BY 
    1
ORDER BY 
    count desc

