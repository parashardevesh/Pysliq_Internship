-- Q-1 What does the "Category_Grouped" column represent, and how many unique categories are there?
SELECT DISTINCT category_grouped AS unique_categories
FROM paytm
WHERE category_grouped IS NOT NULL;

-- Q-2 List the top 5 shipping cities in terms of the number of orders.
SELECT shipping_city AS top_5_shipping_city, COUNT(shipping_city) AS Orders
FROM paytm
GROUP BY shipping_city
ORDER BY Orders DESC 
LIMIT 5;

-- Q-3 Show me a table with all the data for products that belong to the "Electronics" category.
-- there is no electronics category in our dataset
-- we have wathces that may fall in this category
SELECT *
FROM paytm
WHERE class = 'WATCHES';

-- Q-4 Filter the data to show only rows with a "Sale_Flag" of 'Yes'.
SELECT *
FROM paytm
WHERE sale_flag = 'On Sale';

-- Q-5 Sort the data by "Item_Price" in descending order. What is the most expensive item?
SELECT item_nm, category, sub_category, item_price 
FROM paytm
ORDER BY item_price DESC;
-- element soul m black running shoes are the most expensive
-- footwears are most expensive. multiple values with highest price

-- Q-6 Apply conditional formatting to highlight all products with a "Special_Price_effective" value below $50 in red. 

-- Q-7 Create a pivot table to find the total sales value for each category.
-- calculated total sales for each category using sql query
SELECT category, SUM(paid_pr*quantity) as total_sales
FROM paytm
GROUP BY category
ORDER BY total_sales;

-- Q-8 bar chart

--Q-9 Calculate the average "Quantity" sold for products in the "Clothing" category, grouped by "Product_Gender."
SELECT AVG(quantity) as avg_quantity, product_gender
FROM paytm
WHERE category_grouped = 'Apparels' AND sale_flag = 'On Sale'
GROUP BY product_gender;

-- Q-10 Find the top 5 products with the highest "Value_CM1" and "Value_CM2" ratios. 
-- Q-10 Create a chart to visualize this data.
SELECT item_nm as Item_Name, sub_category, category, (value_cm1 / value_cm2) AS top_5_ratio
FROM paytm
ORDER BY top_5_ratio DESC
LIMIT 5;

-- Q-11 Identify the top 3 "Class" categories with the highest total sales. Create a stacked
-- bar chart to represent this data.
SELECT class AS top_3_class, SUM(quantity) AS total_sales
FROM paytm
WHERE class IS NOT NULL
GROUP BY top_3_class
ORDER BY total_sales DESC
LIMIT 3; 

-- Q-12 Find the total sales for each "Brand" and display the top 3 brands in terms of sales.
SELECT SUM(quantity) AS total_sales, brand AS top_3_brands
FROM paytm
GROUP BY top_3_brands
ORDER BY total_sales DESC
LIMIT 3;

-- Q-13 Calculate the total revenue generated from "Electronics" category products with a "Sale_Flag" of 'Yes'.
 -- no electronic product in our dataset
 -- since wathces may be electronic hence calculating for watches
SELECT class, SUM(paid_pr*quantity) AS total_revenue
FROM paytm
WHERE class = 'WATCHES' AND Sale_Flag = 'On Sale'
GROUP BY class;

-- Q-14 Identify the top 5 shipping cities based on the average order value (total sales
-- amount divided by the number of orders) and display their average order values.
SELECT shipping_city, SUM(quantity*paid_pr)/ SUM(quantity) AS avg_order
FROM paytm
GROUP BY shipping_city
ORDER BY avg_order DESC
LIMIT 5; 


--Q -15 Determine the total number of orders and the total sales amount for each
-- "Product_Gender" within the "Clothing" category.
SELECT product_gender, SUM(quantity) AS total_orders, SUM(quantity*paid_pr) AS total_sales
FROM paytm
WHERE category_grouped = 'Apparels'
GROUP BY product_gender; 

-- Q-16 Calculate the percentage contribution of each "Category" to the overall total sales.
SELECT category, 
        CONCAT(ROUND(100.0*COUNT(category) / (
            SELECT COUNT(category) as total_count
            FROM paytm
        ), 2), ' %') AS percentage_contribution
FROM paytm
GROUP BY category; 

-- Q-17 Identify the "Category" with the highest average "Item_Price" and its corresponding average price.

SELECT category, ROUND(AVG(item_price), 2) AS highest_average
FROM paytm
GROUP BY category
ORDER BY highest_average DESC
LIMIT 1;

-- Q-18 Find the month with the highest total sales revenue.
-- there is no date column in our dataset 
-- i have written a query on how to find the month with highest sales revenue
-- this query will not work for our dataset since there is no date column
SELECT MONTH(order_date) AS month, SUM(paid_pr * quantity) as total_sales_revenue
FROM paytm
GROUP BY month
ORDER BY total_sales DESC
LIMIT 1;

-- Q-19 Calculate the total sales for each "Segment" and the average quantity sold per order for each segment.
-- this query calculates total revenue for each segment.
SELECT segment, SUM(quantity * paid_pr) AS total_sales, AVG(quantity) as average_quantity
FROM paytm
GROUP BY segment
ORDER BY total_sales DESC;

-- this one calculates total quantity sold for each segment
SELECT segment, SUM(quantity) AS total_quantity_sold, AVG(quantity) as average_quantity
FROM paytm
GROUP BY segment
ORDER BY total_quantity_sold DESC;
