-- Basic Level Questions
-- List all products with their Product_Type, Cost_$, and Sustainability_Score.

SELECT 
    Product_Type, Cost, Sustainability_Score
FROM
    data;

-- Find products that have a Cost_$ greater than 500 and a Sustainability_Score above 80.

SELECT 
    Product_Type, Cost, Sustainability_Score
FROM
    data
WHERE
    Cost > 500 AND Sustainability_Score > 80;

-- Display products that use more than 100 kg of raw materials but emit less than 200 kg CO2.

SELECT 
    Product_Type
FROM
    data
WHERE
    Raw_Material_Usage_kg > 100
        AND CO2_Emissions_kg < 200;

-- Aggregation and Grouping
-- Find the average Cost_$ for each Product_Type.

SELECT 
    Product_Type, AVG(Cost) AS AvgCost
FROM
    data
GROUP BY Product_Type;

-- Get the minimum, maximum, and average Energy Consumption grouped by Product_Type.

SELECT 
    Product_Type,
    MIN(Energy_Consumption_kWh) AS MinEnergyCunsumption,
    MAX(Energy_Consumption_kWh) AS MaxEnergyCunsumption,
    AVG(Energy_Consumption_kWh) AS AvgEnergyCunsumption
FROM
    data
GROUP BY Product_Type;

-- Count the number of products for each Product_Type.

SELECT 
    Product_Type, COUNT(*) AS CountProductType
FROM
    data
GROUP BY Product_Type;

-- Window Functions (Advanced Level)
-- Rank products within each Product_Type based on their Sustainability_Score (Highest to Lowest) using RANK()

SELECT Product_Type, Sustainability_Score, rank() over( partition by Product_Type order by Sustainability_Score desc) Ranks FROM data;

-- Assign row numbers to all products ordered by Cost_$ descending using ROW_NUMBER().

SELECT Product_Type, Cost, row_number() over( partition by Product_Type order by Cost desc ) as CostRank FROM data;

-- Find the difference in Cost_$ between a product and the product ranked just above it within the same Product_Type using LAG().

SELECT Product_Type, Cost, cost - lag(Cost) over(order by Cost desc) as DiffCost FROM data;

-- NTILE Practice
-- Find the Top 5% most sustainable products based on Sustainability_Score using NTILE(100).


with SustanScore as (
SELECT Product_Type, Sustainability_Score, ntile(100) over( order by Sustainability_Score desc) as topScore FROM data)

select * from SustanScore where topScore <= 5;

-- Find the Bottom 10% products based on Renewable_Energy_% using NTILE(100).

with SustanScoreBt as (
SELECT Product_Type, Renewable_Energy, ntile(100) over( order by Renewable_Energy desc) as topScore FROM data)

select * from SustanScoreBt where topScore >= 91;

-- Subqueries and CTEs
-- Using a CTE, list all products whose Sustainability_Score is higher than the average Sustainability_Score of all products.

SELECT 
    Product_Type, Sustainability_Score
FROM
    data
WHERE
    Sustainability_Score > (SELECT 
            AVG(Sustainability_Score)
        FROM
            data);
            
 -- Find products whose Cost_$ is greater than the average Cost_$ of their Product_Type.

SELECT 
    Product_Type, Cost
FROM
    data
WHERE
    Cost > (SELECT 
            AVG(Cost)
        FROM
            data);
 
--  Bonus Professional Questions
-- Create a CASE statement that categorizes products as:
-- 'Highly Sustainable' if Sustainability_Score > 85
-- 'Moderately Sustainable' if 60 < Sustainability_Score <= 85
-- 'Low Sustainability' if Sustainability_Score <= 60

SELECT 
    Product_Type,
    Sustainability_Score,
    CASE
        WHEN Sustainability_Score > 85 THEN 'Highly Sustainable'
        WHEN Sustainability_Score BETWEEN 60 AND 85 THEN 'Moderately Sustainable'
        ELSE 'Low Sustainability'
    END AS SustainCategory
FROM
    data;

-- Create a CTE to calculate the average CO2_Emissions_kg and find products emitting less than the average.
SELECT 
    *
FROM
    data;



with CTE as ( 
SELECT Product_Type, CO2_Emissions_kg FROM data where CO2_Emissions_kg < (select avg(CO2_Emissions_kg) from data))

select * from CTE;