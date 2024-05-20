-- Q-1 Retrieve all columns for all records in the dataset.
SELECT * 
FROM pharma;

-- Q-2 How many unique countries are represented in the dataset?
SELECT DISTINCT Country
FROM pharma;

-- Q-3 Select the names of all the customers on the 'Retail' channel.
SELECT "Customer Name" AS Retail_customer
FROM pharma
WHERE "Sub-Channel" = 'Retail';

-- Q-4 Find the total quantity sold for the ' Antibiotics' product class.
SELECT ROUND(SUM(Quantity)) AS total_quantity_sold
FROM pharma
WHERE "Product Class" = 'Antibiotics';

--Q-5 List all the distinct months present in the dataset.
SELECT DISTINCT Month
FROM pharma;

-- Q-6 Calculate the total sales for each year.
SELECT Year, ROUND(SUM(Sales) / 1000000, -1) AS "total_sales (in millions)"
FROM pharma
GROUP BY Year;

-- Q-7 Find the customer with the highest sales value.
SELECT DISTINCT "Customer Name", ROUND(Sales / 1000000) AS "Highest_sales (in millions)"
FROM pharma
ORDER BY Sales
LIMIT 1;

-- Q-8 Get the names of all employees who are Sales Reps and are managed by 'James Goodwill'.
SELECT DISTINCT "Name of Sales Rep", Manager
FROM pharma
WHERE Manager = 'James Goodwill';

-- Q-9 Retrieve the top 5 cities with the highest sales.
SELECT city, ROUND(Sales / 1000000) AS "Total Sales (in millions)"
FROM pharma
ORDER BY Sales DESC
LIMIT 5;

--Q-10 Calculate the average price of products in each sub-channel.
SELECT "Sub-channel", ROUND(AVG(Price)) AS products_avg_price
FROM pharma
GROUP BY "Sub-channel";

-- Q-11 Join the 'Employees' table with the 'Sales' table to get the name of the Sales Rep 
-- and the corresponding sales records.
-- Only one table available, also without joining it can be solved
SELECT "Name of Sales Rep", ROUND(SUM("Sales") / 1000000) AS "total_sales (in millions)"
FROM pharma
GROUP BY "Name of Sales Rep";

-- Q-12 Retrieve all sales made by employees from ' Rendsburg ' in the year 2018.
SELECT "Name of Sales Rep", ROUND(SUM(Sales) / 1000) AS "total_sales (in thousands)"
FROM pharma
WHERE city = 'Rendsburg' AND Year = 2018
GROUP BY "Name of Sales Rep", City, Year;

-- Q-13 Calculate the total sales for each product class, for each month, 
-- and order the results by year, month, and product class.
SELECT "Product Class", month, year, 
    ROUND(SUM(sales) / 1000000) AS "Total_sales (in millions)"
FROM pharma
GROUP BY year, month, "Product Class"
ORDER BY year, month, "Product Class";

-- Q-14 Find the top 3 sales reps with the highest sales in 2019.
SELECT "Name of Sales Rep" AS Top_3_Sales_Representative, 
    ROUND(SUM(sales) / 1000000, -1) AS "Total_sales (in millions)"
FROM pharma
WHERE Year = 2019
GROUP BY Top_3_Sales_Representative
ORDER BY "Total_sales (in millions)" DESC
LIMIT 3;

-- Q-15 Calculate the monthly total sales for each sub-channel, 
-- and then calculate the average monthly sales for each sub-channel over the years.
SELECT "Sub-channel", Month, Year, 
    ROUND(SUM(sales) / 1000000) AS "Total_Sales (in millions)",
    ROUND(AVG(sales) / 1000) AS "Avg_Sales (in thousands)"
FROM pharma
GROUP BY "Sub-channel", Year, Month
ORDER BY Year, Month, "Total_Sales (in millions)" DESC;

-- Q-16 Create a summary report that includes the total sales, average price, 
-- and total quantity sold for each product class.
SELECT "Product Class", ROUND(SUM(sales) / 1000000000, 2) AS "Total_sales (in billions)",
    ROUND(AVG(Price), 2) AS Average_price,
    ROUND(SUM(Quantity) / 1000000, 2) AS "Total_quantity (in millions)"
FROM pharma
GROUP BY "Product Class"
ORDER BY "Total_sales (in billions)" DESC;

-- Q-17 Find the top 5 customers with the highest sales for each year.
WITH sales_cte AS (
    SELECT 
        "Customer Name", Year, SUM(sales) AS Total_sales,
        RANK() OVER (PARTITION BY Year ORDER BY SUM(sales) DESC) AS rn
    FROM pharma
    GROUP BY "Customer Name", Year
)
SELECT "Customer Name", Year, Total_sales
FROM sales_cte
WHERE rn >= 5
ORDER BY Year, Total_sales DESC;

-- Q-18 Calculate the year-over-year growth in sales for each country.
SELECT country, year, 
    ROUND( (SUM(sales) - LAG(SUM(sales)) OVER (ORDER BY year)) / 1000000000, 3) AS "YOY_Growth (in billions)"
FROM pharma
GROUP BY year, country
OFFSET 1;

-- Q-19 List the months with the lowest sales for each year
WITH low_sales_per_year AS (
    SELECT year, month, SUM(sales) AS lowest_sales, 
        RANK() OVER (PARTITION BY year ORDER BY lowest_sales) AS rn
    FROM pharma
    GROUP BY year, month
)
SELECT year, month, ROUND(lowest_sales / 1000000, 2) AS "lowest_sales (in millions)"
FROM low_sales_per_year
WHERE rn=1;

-- Q-20 Calculate the total sales for each sub-channel in each country, 
-- and then find the country with the highest total sales for each sub-channel.
SELECT country, "sub-channel", ROUND(total_sales / 1000000000, 3) AS "total_sales (in billions)"
FROM 
    (
        SELECT country, "sub-channel", SUM(sales) AS total_sales,
            RANK() OVER(PARTITION BY "sub-channel" ORDER BY total_sales DESC) AS rn
        FROM pharma
        GROUP BY country, "sub-channel"
    )
WHERE rn = 1; 