# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Sales Analysis    
**Database**: `p1_retail_db`

This project demonstrates core SQL skills typically used by data analysts to explore, clean, and analyze retail sales data. It involves setting up a relational retail database, performing exploratory data analysis (EDA), and answering real-world business questions through SQL — using advanced techniques such as subqueries, Common Table Expressions (CTEs

## Objectives

1. **Set up a retail sales database**: Set up a relational database using downloaded retail sales data as a foundation for SQL-based analytics.
2. **Data Cleaning**: Clean and transform raw retail data using SQL.(ex:- removing null values)
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Answer business questions like:
Who are the top customers?
Which month was the best selling?
Which category is generating least revenue?

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `p1_retail_db`.
- **Table Creation**: Created a sales table to store transactional data, including fields such as transaction ID, sale date and time, customer demographics (ID, gender, age), product category, quantity sold, unit price, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE project1;

CREATE TABLE sales
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
```

### 2. Importing Data

```sql 
COPY SALES 
FROM 'C:\SQL\sql_load\SQL - Retail Sales Analysis_utf .csv'
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',', QUOTE '"',ENCODING 'UTF-8');
```

### 3. Data Exploration & Cleaning

- **Total Records**: Counted the total number of transactions in the dataset to understand its volume..
- **Unique Customers**: Identified the number of distinct customers to assess customer base size.
- **Product Categories**: Extracted and analyzed unique product categories to understand product diversity.
- **Data Quality Check**: Performed null value checks and removed records with missing or incomplete data to ensure data integrity.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;



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

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;


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

```

### 4. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1.**Which month has the highest sales**:
```sql
SELECT SUM(quantity*price_per_unit) as sale,
EXTRACT(month from sale_date) as month
FROM sales
GROUP BY MONTH
ORDER BY
sale desc
```

2. **What is the total Revenue generated**:
```sql
SELECT SUM(total_sale) as total_revenue from sales;
```

3. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM sales
WHERE sale_date = '2022-11-05';
```

4. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 2 in the month of Nov-2022**:
```sql
SELECT *
        From
        sales
WHERE
    category = 'Clothing' 
    AND  quantity > 2
    AND  sale_date >= '2022-11-01'
    AND  sale_date < '2022-12-01';

```

5. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT category,
SUM(price_per_unit*quantity) as saledone, 
COUNT(category) as totalorders
from sales
GROUP BY 1;
```

6. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT 
    ROUND(AVG(age),3) as avg_a
From 
    sales
Where
    category = 'Beauty';

```

7. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT 
    *
FROM
    sales
WHERE   
    total_sale > 1000; 
```

8. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql

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
```

9. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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
```

10. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
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
```

11. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT
    COUNT(DISTINCT(customer_id)) as unique_customers,
    category
FROM
    sales
GROUP BY 
    2
```

12. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql

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
```

## Findings

- **Customer Demographics**: The analysis identifies the top-spending customers and the most popular product categories.
- **High-Value Transactions**: Multiple transactions recorded a total sale amount exceeding 2000, indicating high-value or premium purchases.
- **Sales Trends**: Monthly sales analysis reveals significant fluctuations, helping to identify peak seasons and sales trends over time
- **Customer Insights**: The analysis highlights the top-spending customers and pinpoints the most popular product categories based on purchase frequency and revenue contribution.

## Reports

- **Sales Summary**: A comprehensive report summarizing total sales, customer demographics, and the performance of each product category.
- **Trend Analysis**: Insights into monthly sales trends and seasonal shifts in consumer behaviour
- **Customer Insights**: Detailed reports highlighting top-spending customers and the number of unique customers per product category.

## Conclusion

This project provided valuable hands-on experience in analyzing retail sales data using SQL. Through the use of subqueries, Common Table Expressions (CTEs), and various analytical queries, key insights were derived regarding customer demographics, product category performance, and sales trends over time. The analysis not only highlighted high-value customers and peak sales periods but also ensured data quality through proper cleaning and validation. Overall, this project showcases foundational SQL skills essential for data analysis and business decision-making.


