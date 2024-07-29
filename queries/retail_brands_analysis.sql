-- Brand Preferences Analysis

-- 1. Do different age groups prefer different products/brands?
-- This query ranks the popularity of brands within each age group.

WITH age_cte AS (
    SELECT 
        age_group,
        product_brand,
        COUNT(DISTINCT customer_id) AS No_of_Customers
    FROM customer_transactions
    GROUP BY age_group, product_brand
)
SELECT 
    age_group,
    product_brand,
    No_of_Customers,
    DENSE_RANK() OVER (PARTITION BY age_group ORDER BY No_of_Customers DESC) AS brand_pop_by_age
FROM age_cte;
-- Example Insights: Zara is the most popular among 18-25, Nike 26-35, Zara 36-45, 46-55, Adidas 56-65, Adidas 65+

-- 2. Brand preferences by gender
-- This query shows the number of customers for each brand, segmented by gender.

SELECT 
    gender,
    product_brand,
    COUNT(DISTINCT customer_id) AS No_of_Customers
FROM customer_transactions
GROUP BY gender, product_brand;

-- Example Insights: Zara is more popular among females, and Adidas among males

-- 3. Most popular brand by gender
-- This query ranks the brands by popularity within each gender.

WITH brand_cte AS (
    SELECT 
        gender,
        product_brand,
        COUNT(DISTINCT customer_id) AS No_of_Customers
    FROM customer_transactions
    GROUP BY gender, product_brand
)
SELECT 
    gender,
    product_brand,
    No_of_Customers,
    RANK() OVER (PARTITION BY gender ORDER BY No_of_Customers DESC) AS brand_rank
FROM brand_cte;
-- Example Insights: Zara for women, Adidas for men

-- 4. Income levels vs brand preferences and product preferences
-- This query shows the number of customers and total spending for each brand, segmented by income level.

SELECT 
    income,
    product_brand,
    COUNT(DISTINCT customer_id) AS No_of_Customers,
    SUM(amount) AS total_spending
FROM customer_transactions
GROUP BY income, product_brand;

-- 5. Brand Loyalty by Generation or Age group
-- This query shows the number of customers for each brand, segmented by generation.

SELECT 
    product_brand,
    COUNT(DISTINCT customer_id) AS customer_count,
    generation
FROM customer_transactions
GROUP BY product_brand, generation
ORDER BY product_brand;
-- Example Insights: Gen-Z is the most popular among each brand