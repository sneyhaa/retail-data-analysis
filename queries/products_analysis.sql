-- 1. Most Popular Products by Type
-- This query finds the top 5 most bought products for each product type based on total purchases.

WITH product_purchases AS (
    SELECT 
        product_type,
        products,
        SUM(Total_Purchases) AS total_bought
    FROM customer_transactions
    GROUP BY product_type, products
),
ranked_products AS (
    SELECT *,
        RANK() OVER (PARTITION BY product_type ORDER BY total_bought DESC) AS rank
    FROM product_purchases
)
SELECT *
FROM ranked_products
WHERE rank <= 5;

-- 2. Top 5 Highest Rated Products by Type
-- This query selects the top 5 highest-rated products within each product type.

WITH product_ratings AS (
    SELECT 
        product_type,
        products,
        ROUND(AVG(ratings),2) AS avg_ratings
    FROM customer_transactions
    GROUP BY product_type, products
),
ranked_ratings AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY product_type ORDER BY avg_ratings DESC) AS rank
    FROM product_ratings
)
SELECT * 
FROM ranked_ratings 
WHERE rank <= 5;

-- 3. Frequently Bought Products by Generation
-- This query lists the top 10 most frequently bought products for each generation.

WITH gen_purchases AS (
    SELECT 
        generation,
        product_type,
        products,
        SUM(total_purchases) AS purchase_count
    FROM customer_transactions
    GROUP BY generation, product_type, products
),
ranked_gen_purchases AS (
    SELECT *,
        DENSE_RANK() OVER (PARTITION BY generation ORDER BY purchase_count DESC) AS rank
    FROM gen_purchases
)
SELECT * 
FROM ranked_gen_purchases
WHERE rank <= 10;

-- 4. Top 5 Favorite Products Among Each Generation
-- This query identifies the top 5 most popular products among each generation based on customer count.

WITH gen_favorites AS (
    SELECT 
        generation,
        product_type,
        products,
        COUNT(DISTINCT customer_id) AS customer_count
    FROM customer_transactions
    GROUP BY generation, product_type, products
),
ranked_gen_favorites AS (
    SELECT *,
        DENSE_RANK() OVER (PARTITION BY generation ORDER BY customer_count DESC) AS rank
    FROM gen_favorites
)
SELECT * 
FROM ranked_gen_favorites
WHERE rank <= 5;

-- 5. Popular Products by Income Group
-- This query shows the top 10 favorite products by each income group based on customer count.

WITH income_favorites AS (
    SELECT 
        income,
        product_type,
        products,
        COUNT(DISTINCT customer_id) AS customer_count
    FROM customer_transactions
    GROUP BY income, product_type, products
),
ranked_income_favorites AS (
    SELECT *,
        DENSE_RANK() OVER (PARTITION BY income ORDER BY customer_count DESC) AS rank
    FROM income_favorites
)
SELECT * 
FROM ranked_income_favorites
WHERE rank <= 10;

-- 6. Popular Products by Gender
-- This query finds the top 10 favorite products for each gender based on customer count.

WITH gender_favorites AS (
    SELECT 
        gender,
        products,
        COUNT(DISTINCT customer_id) AS customer_count
    FROM customer_transactions
    GROUP BY gender, products
),
ranked_gender_favorites AS (
    SELECT *,
        DENSE_RANK() OVER (PARTITION BY gender ORDER BY customer_count DESC) AS rank
    FROM gender_favorites
)
SELECT products, gender, customer_count, rank
FROM ranked_gender_favorites
WHERE rank <= 10;

-- 7. Do High-Income Customers Buy More Premium Products?
-- This query analyzes the product preferences of high-income customers based on purchase count.

WITH income_analysis AS (
    SELECT 
        income,
        products,
        COUNT(DISTINCT customer_id) AS No_of_Customers,
        SUM(total_purchases) AS purchases
    FROM customer_transactions
    GROUP BY income, products
)
SELECT *,
    DENSE_RANK() OVER (PARTITION BY income ORDER BY purchases DESC) AS rank
FROM income_analysis
WHERE income = 'High';

-- 8. How Product Preferences Vary by Low Income Levels
-- This query investigates the product preferences of low-income customers, particularly for 'Oxfords'.

SELECT *
FROM income_analysis
WHERE income = 'Low' AND products = 'Oxfords';

-- 9. Low Income Bracket Product Preference/Popularity
-- This query identifies the top 10 products preferred by customers in the low-income bracket based on customer count.

SELECT *
FROM income_analysis
WHERE income = 'Low' AND rank <= 10;

-- 10. Most Revenue-Generating Products by Income Bracket
-- This query finds the products that generate the most revenue among each income bracket.

WITH revenue_analysis AS (
    SELECT 
        income,
        products,
        COUNT(DISTINCT customer_id) AS No_of_Customers,
        SUM(amount) AS total_spending
    FROM customer_transactions
    GROUP BY income, products
),
ranked_revenue AS (
    SELECT *,
        DENSE_RANK() OVER (PARTITION BY income ORDER BY total_spending DESC) AS rank
    FROM revenue_analysis
)
SELECT *
FROM ranked_revenue
WHERE income = 'High' AND rank <= 10;

-- 11. Popular Products by Gender - Female
-- This query lists the top 10 popular products among female customers based on customer count.

SELECT *
FROM ranked_gender_favorites
WHERE gender = 'Female' AND rank <= 10;

-- 12. Popular Products by Gender - Male
-- This query lists the top 10 popular products among male customers based on customer count.

SELECT *
FROM ranked_gender_favorites
WHERE gender = 'Male' AND rank <= 10;

-- 13. Spending by Gender - Female
-- This query shows the top 10 products by spending among female customers.

WITH spending_by_gender AS (
    SELECT 
        gender,
        products,
        SUM(amount) AS total_spending
    FROM customer_transactions
    GROUP BY gender, products
),
ranked_spending_female AS (
    SELECT *,
        DENSE_RANK() OVER (PARTITION BY gender ORDER BY total_spending DESC) AS rank
    FROM spending_by_gender
)
SELECT *
FROM ranked_spending_female
WHERE gender = 'Female' AND rank <= 10;

-- 14. Spending by Gender - Male
-- This query shows the top 10 products by spending among male customers.

SELECT *
FROM ranked_spending_female
WHERE gender = 'Male' AND rank <= 10;

-- 15. Product Popularity by Age Group
-- This query identifies the top 5 most popular products for each age group based on customer count.

WITH age_analysis AS (
    SELECT 
        age_group,
        products,
        COUNT(DISTINCT customer_id) AS No_of_Customers
    FROM customer_transactions
    GROUP BY age_group, products
),
ranked_age_analysis AS (
    SELECT 
        age_group, products, No_of_Customers,
        DENSE_RANK() OVER (PARTITION BY age_group ORDER BY No_of_Customers DESC) AS rank
    FROM age_analysis
)
SELECT * 
FROM ranked_age_analysis 
WHERE rank <= 5;

-- 16. Popular Products by Gender
-- This query finds the top 5 products for each gender.

WITH gender_product_favorites AS (
    SELECT 
        gender,
        products,
        COUNT(DISTINCT customer_id) AS No_of_Customers
    FROM customer_transactions
    GROUP BY gender, products
),
ranked_gender_product AS (
    SELECT 
        gender, products, No_of_Customers,
        RANK() OVER (PARTITION BY gender ORDER BY No_of_Customers DESC) AS rank
    FROM gender_product_favorites
)
SELECT * 
FROM ranked_gender_product
WHERE rank <= 5;