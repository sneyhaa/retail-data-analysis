-- AOV/CLV
-- How does customer lifetime value (CLV) vary by demographic segments?
-- CLV = Customer Value * Average Customer Lifespan
-- Customer Value = Average Purchase Value * Average Purchase Frequency
-- CLV = AOV * PF * CL

-- Calculate Average Order Value (AOV), Purchase Frequency (PF), and Customer Lifespan (CL)
WITH aov AS (
    SELECT 
        customer_id, 
        ROUND(SUM(amount) / SUM(total_purchases), 2) AS AOV_per_cust
    FROM customer_transactions 
    GROUP BY customer_id
),
pf AS (
    SELECT 
        customer_id, 
        SUM(total_purchases) / COUNT(*) AS PF_per_cust
    FROM customer_transactions 
    GROUP BY customer_id
),
cl AS (
    SELECT 
        customer_id,
        MAX(date) - MIN(date) AS lifespan_days,
        ROUND((MAX(date) - MIN(date)) / 30.44, 1) AS lifespan_months
    FROM customer_transactions 
    GROUP BY customer_id 
)

-- Calculate CLV and list top 10 customers
SELECT 
    aov.customer_id, 
    aov.AOV_per_cust,
    pf.PF_per_cust,
    cl.lifespan_months,
    (aov.AOV_per_cust * pf.PF_per_cust * cl.lifespan_months) AS CLV_per_cust
FROM aov 
JOIN pf ON aov.customer_id = pf.customer_id
JOIN cl ON pf.customer_id = cl.customer_id
ORDER BY CLV_per_cust DESC 
LIMIT 10;


--CLV
--What is the average CLV for different age groups, genders, and income levels?

--CLV by age group
-- Calculate CLV metrics for each age group
WITH aov AS (
    SELECT 
        age_group,
        ROUND(SUM(amount) / SUM(total_purchases), 2) AS AOV_by_agegrp
    FROM customer_transactions 
    GROUP BY age_group
),
pf AS (
    SELECT 
         age_group, 
        SUM(total_purchases) / COUNT(*) AS PF_by_agegrp
    FROM customer_transactions 
    GROUP BY age_group
),
cl AS (
    SELECT 
        age_group,
        MAX(date) - MIN(date) AS lifespan_days,
        ROUND((MAX(date) - MIN(date)) / 30.44, 1) AS lifespan_months_by_agegrp
    FROM customer_transactions 
    GROUP BY age_group 
)

-- Calculate CLV by age group
SELECT 
    aov.age_group, 
    aov.AOV_by_agegrp,
    pf.PF_by_agegrp,
    cl.lifespan_months_by_agegrp,
    (aov.AOV_by_agegrp * pf.PF_by_agegrp * cl.lifespan_months_by_agegrp) AS CLV_by_agegrp
FROM aov 
JOIN pf ON aov.age_group = pf.age_group
JOIN cl ON pf.age_group = cl.age_group
ORDER BY CLV_by_agegrp DESC 
LIMIT 10;


-- CLV by gender
-- Calculate CLV metrics for each gender
WITH aov_gender AS (
    SELECT 
        gender,
        ROUND(SUM(amount) / SUM(total_purchases), 2) AS AOV_by_gender
    FROM customer_transactions 
    GROUP BY gender
),
pf_gender AS (
    SELECT 
         gender, 
        SUM(total_purchases) / COUNT(*) AS PF_by_gender
    FROM customer_transactions 
    GROUP BY gender
),
cl_gender AS (
    SELECT 
        gender,
        MAX(date) - MIN(date) AS lifespan_days,
        ROUND((MAX(date) - MIN(date)) / 30.44, 1) AS lifespan_months_by_gender
    FROM customer_transactions 
    GROUP BY gender 
)

-- Calculate CLV by gender
SELECT 
    aov_gender.gender, 
    aov_gender.AOV_by_gender,
    pf_gender.PF_by_gender,
    cl_gender.lifespan_months_by_gender,
    (aov_gender.AOV_by_gender * pf_gender.PF_by_gender * cl_gender.lifespan_months_by_gender) AS CLV_by_gender
FROM aov_gender 
JOIN pf_gender ON aov_gender.gender = pf_gender.gender
JOIN cl_gender ON pf_gender.gender = cl_gender.gender
ORDER BY CLV_by_gender DESC 
LIMIT 10;


-- CLV by income
-- Calculate CLV metrics for each income level
WITH aov AS (
    SELECT 
        income,
        ROUND(SUM(amount) / SUM(total_purchases), 2) AS AOV_by_income
    FROM customer_transactions 
    GROUP BY income
),
pf AS (
    SELECT 
         income, 
        SUM(total_purchases) / COUNT(*) AS PF_by_income
    FROM customer_transactions 
    GROUP BY income
),
cl AS (
    SELECT 
        income,
        MAX(date) - MIN(date) AS lifespan_days,
        ROUND((MAX(date) - MIN(date)) / 30.44, 1) AS lifespan_months_by_income
    FROM customer_transactions 
    GROUP BY income
)

-- Calculate CLV by income
SELECT 
    aov.income, 
    aov.AOV_by_income,
    pf.PF_by_income,
    cl.lifespan_months_by_income,
    (aov.AOV_by_income * pf.PF_by_income* cl.lifespan_months_by_income) AS CLV_by_income
FROM aov 
JOIN pf ON aov.income = pf.income
JOIN cl ON pf.income = cl.income
ORDER BY CLV_by_income DESC 
LIMIT 10;



