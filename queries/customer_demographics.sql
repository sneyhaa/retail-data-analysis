-- SQL Analysis on customer-transactions dataset

-- Sample Data
-- Objective: Fetch a sample of the customer transactions data.
SELECT * FROM customer_transactions LIMIT 10;

-- Customer Analysis
-- Objective: Understand the characteristics of different customer segments.

-- CUSTOMER DEMOGRAPHICS

-- 1. Age Distribution
-- What is the age distribution of our customers?
SELECT 
    age_group,
    COUNT(customer_id) AS customers_by_age_group
FROM customer_transactions
GROUP BY age_group;

-- 2. Generation Distribution
-- What is the distribution of customers by generation?
SELECT 
    generation,
    COUNT(DISTINCT customer_id) AS number_of_customers
FROM customer_transactions
GROUP BY generation 
ORDER BY number_of_customers DESC;

-- 3. Gender Distribution
-- What is the gender distribution of our customers?
SELECT 
    gender,
    COUNT(DISTINCT customer_id) AS customers_by_gender
FROM customer_transactions
GROUP BY gender;

-- 4. Income Group Distribution
-- What is the distribution of customers by income group?
SELECT 
    income,
    COUNT(DISTINCT customer_id) AS customers_by_income
FROM customer_transactions
GROUP BY income;

-- CUSTOMER SPENDING HABITS

-- 1. Spending Habits by Gender
-- How do spending habits vary by gender?
SELECT 
    gender,
    COUNT(DISTINCT customer_id) AS no_of_customers,
    COUNT(total_purchases) AS total_purchases,
    SUM(amount) AS total_spending
FROM customer_transactions
GROUP BY gender;

-- 2. Spending Habits by Income Level
-- How does purchasing behavior vary by income level?
SELECT 
    income,
    COUNT(DISTINCT customer_id) AS no_of_customers,
    SUM(total_purchases) AS total_purchases,
    SUM(amount) AS total_spending
FROM customer_transactions
GROUP BY income;

-- 3. Average Spending per Order by Age Group
-- What is the average amount spent per order by age group?
SELECT 
    age_group,
    ROUND(AVG(amount), 2) AS avg_spent_per_order
FROM customer_transactions
GROUP BY age_group;

-- 4. Purchase Frequency by Gender
-- What is the purchase frequency by gender?
SELECT 
    gender,
    SUM(total_purchases) AS purchase_frequency
FROM customer_transactions
GROUP BY gender;





