select * from `brightmotor`.`default`.`car_sales_data` limit 100;


----Checking the date range
SELECT MIN(year) AS start_date,
       MAX(year) AS end_date
FROM `brightmotor`.`default`.`car_sales_data`;
   

----Checking how many makes and models we have
SELECT DISTINCT model
 FROM `brightmotor`.`default`.`car_sales_data`;
     

 SELECT DISTINCT make
 FROM `brightmotor`.`default`.`car_sales_data`;
          

---Checking for NULLS
---year doesn't have nulls
SELECT `year`
FROM `brightmotor`.`default`.`car_sales_data`
WHERE `year` IS NULL;


SELECT make
FROM `brightmotor`.`default`.`car_sales_data`      
WHERE make IS NULL;

      
SELECT `model`
FROM `brightmotor`.`default`.`car_sales_data`      
WHERE `model` IS NULL;


SELECT `trim`
FROM `brightmotor`.`default`.`car_sales_data`      
WHERE`trim` IS NULL;

       
SELECT body
FROM `brightmotor`.`default`.`car_sales_data`      
WHERE body IS NULL;

       
SELECT transmission
FROM `brightmotor`.`default`.`car_sales_data`      
WHERE transmission IS NULL;


 ---vin doesn't have any nulls     
SELECT vin
FROM `brightmotor`.`default`.`car_sales_data`      
WHERE vin IS NULL;


---state doesn't have any nulls      
SELECT state
FROM `brightmotor`.`default`.`car_sales_data`      
WHERE state IS NULL;

     
SELECT `condition`
FROM `brightmotor`.`default`.`car_sales_data`      
WHERE  `condition` IS NULL;

      
SELECT odometer
FROM `brightmotor`.`default`.`car_sales_data`      
WHERE odometer IS NULL;

      
SELECT color
FROM `brightmotor`.`default`.`car_sales_data`      
WHERE color IS NULL;

    
SELECT interior
FROM `brightmotor`.`default`.`car_sales_data`      
WHERE  interior IS NULL;


 ---seller doesn't have any nulls    
SELECT seller
FROM `brightmotor`.`default`.`car_sales_data`      
WHERE  seller IS NULL;

     
SELECT mmr
FROM `brightmotor`.`default`.`car_sales_data`      
WHERE  mmr IS NULL;

      
SELECT selling_price
FROM `brightmotor`.`default`.`car_sales_data`      
WHERE selling_price IS NULL;

      
SELECT sale_date
FROM `brightmotor`.`default`.`car_sales_data`      
WHERE sale_date IS NULL;


 SELECT COUNT(*),
        `condition`
 FROM   `brightmotor`.`default`.`car_sales_data`
 WHERE `condition` IS NULL
 GROUP BY `condition`;
 

SELECT COUNT(vin) AS number_of_units_sold
FROM  `brightmotor`.`default`.`car_sales_data`;

 
 ----Calculating total revenue
SELECT SUM(selling_price) AS Total_Revenue
FROM  `brightmotor`.`default`.`car_sales_data`;


----Revenue by car make and model
SELECT SUM(selling_price) AS Total_Revenue,
       make,
       `model`
FROM  `brightmotor`.`default`.`car_sales_data`
GROUP BY make,
        `model`;
          
---Sales distribution by year
SELECT SUM(selling_price) AS Total_Revenue,
       `year`
FROM  `brightmotor`.`default`.`car_sales_data`
GROUP BY `year`;


----Regional performance
SELECT SUM(selling_price) AS Total_Revenue,
       state
FROM  `brightmotor`.`default`.`car_sales_data`
GROUP BY state;
  

----Average selling price overtime
SELECT AVG(selling_price) AS Average_price,
      `year`
      FROM  `brightmotor`.`default`.`car_sales_data`
      GROUP BY `year`;

---Calculating profit margins
SELECT 
      ROUND((selling_price - mmr) / selling_price * 100, 2) AS profit_margin
FROM   `brightmotor`.`default`.`car_sales_data`;          


----Grouping into time buckets
----transforming the sale_date column into a timestamp
 SELECT 
  TO_TIMESTAMP(REGEXP_REPLACE(sale_date, '^[A-Za-z]{3} ', ''),'MMM d yyyy HH:mm:ss') AS sale_timestamp
FROM `brightmotor`.`default`.`car_sales_data`;
---Extracting day and month names
SELECT 
  TO_TIMESTAMP(REGEXP_REPLACE(sale_date, '^[A-Za-z]{3} ', ''), 'MMM d yyyy HH:mm:ss') AS sale_timestamp,
  date_format(TO_TIMESTAMP(REGEXP_REPLACE(sale_date, '^[A-Za-z]{3} ', ''), 'MMM d yyyy HH:mm:ss'), 'EEEE') AS day_name,
  date_format(TO_TIMESTAMP(REGEXP_REPLACE(sale_date, '^[A-Za-z]{3} ', ''), 'MMM d yyyy HH:mm:ss'), 'MMMM') AS month_name
FROM `brightmotor`.`default`.`car_sales_data`;

---Replacing null values
SELECT 
       IFNULL(`year`,0) AS `year`,
       IFNULL(make,'no make') AS make,
       IFNULL(`model`,'no model') AS `model`,
       IFNULL(`trim`,'no trim') AS `trim`,
       IFNULL(body, 'no body') AS body,
       IFNULL(transmission, 'no transmission') AS transmission,
       IFNULL(vin,'no vin') AS vin,
       IFNULL(state,'no state') AS state,
       IFNULL(`condition`,0) AS `condition`,
       IFNULL(odometer,0) AS odometer,
       IFNULL(color,'no color') AS color,
       IFNULL(interior, 'no interior') AS interior,
       IFNULL(seller,'no seller') AS seller,
       IFNULL(mmr,0) AS mmr,
       IFNULL(selling_price,0) AS selling_price,
       IFNULL(sale_date,'no date') AS sale_date
FROM  `brightmotor`.`default`.`car_sales_data`;       

----Replacing nulls and empty cells
SELECT
  COALESCE(`year`,0) AS `year`,
  COALESCE(NULLIF(make, ''), 'no make') AS make,
  COALESCE(NULLIF(`model`, ''), 'no model') AS model,
  COALESCE(NULLIF(`trim`,''),'no trim') AS `trim`,
  COALESCE(NULLIF(body,''), 'no body') AS body,
  COALESCE(NULLIF(transmission, ''), 'no transmission') AS transmission,
  COALESCE(NULLIF(vin, ''), 'no vin') AS vin,
  COALESCE(NULLIF(state, ''), 'no state') AS state,
  COALESCE(`condition`,0) AS `condition`,
  COALESCE(odometer,0) AS odometer,
  COALESCE(NULLIF(NULLIF(color, ''),'—'), 'no color') AS color,
  COALESCE(NULLIF(interior, ''), 'no interior') AS interior,
  COALESCE(NULLIF(seller, ''), 'no seller') AS seller,
  COALESCE(mmr,0) AS mmr,
  COALESCE(selling_price,0) AS selling_price,
  COALESCE(NULLIF(sale_date, ''), 'no sale date') AS sale_date
FROM `brightmotor`.`default`.`car_sales_data`;





----CASE STATEMENTS

---1.1 GROUPING CARS ACCORDING TO THEIR TOTAL MILEAGE
SELECT *,
       CASE
           WHEN odometer < 50000 THEN 'Low Mileage'
           WHEN odometer BETWEEN 50000 AND 100000 THEN 'Moderate Mileage'
           WHEN odometer BETWEEN 100000 AND 200000 THEN 'High Mileage'
           ELSE 'Very High Mileage'
           END AS Total_Mileage
FROM `brightmotor`.`default`.`car_sales_data`;     

---1.2 GROPING CARS ACCORDING TO PRICE
SELECT *,
      CASE 
      WHEN selling_price < 20000 THEN 'Budget cars'
      WHEN selling_price BETWEEN 20000 and 40000 THEN 'Mid-range cars'
      WHEN selling_price BETWEEN 40000 AND 70000 THEN 'Upper mid-range cars'
      ELSE 'Premium cars'
      END AS Price_Category
      FROM  `brightmotor`.`default`.`car_sales_data`;     


SELECT state
FROM `brightmotor` . `default` . `car_sales_data`
WHERE state='—';

----FINAL CODE
SELECT
---Replacing NULLS, EM DASHES AND EMPTY CELLS
       COALESCE(`year`,0) AS `year`,
       COALESCE(NULLIF(make, ''), 'no make') AS make,
       COALESCE(NULLIF(`model`, ''), 'no model') AS model,
       COALESCE(NULLIF(`trim`,''),'no trim') AS `trim`,
       COALESCE(NULLIF(body,''), 'no body') AS body,
       COALESCE(NULLIF(transmission, ''), 'no transmission') AS transmission,
       COALESCE(NULLIF(vin, ''), 'no vin') AS vin,
       COALESCE(NULLIF(state, ''), 'no state') AS state,
       COALESCE(`condition`,0) AS `condition`,
       COALESCE(odometer,0) AS odometer,
       COALESCE(NULLIF(NULLIF(color, ''),'—'), 'no color') AS color,
       COALESCE(NULLIF (NULLIF(interior, ''),'—'), 'no interior') AS interior,
       COALESCE(NULLIF(seller, ''), 'no seller') AS seller,
       COALESCE(mmr,0) AS mmr,
       COALESCE(selling_price,0) AS selling_price,
       COALESCE(NULLIF(sale_date, ''), 'no sale date') AS sale_date,

---Transforming the date column into a timestamp
      TO_TIMESTAMP(REGEXP_REPLACE(sale_date, '^[A-Za-z]{3} ', ''),'MMM d yyyy HH:mm:ss') AS sale_timestamp,
---Extracting day and month names
       date_format(TO_TIMESTAMP(REGEXP_REPLACE(sale_date, '^[A-Za-z]{3} ', ''), 'MMM d yyyy HH:mm:ss'), 'EEEE') AS day_name,
       date_format(TO_TIMESTAMP(REGEXP_REPLACE(sale_date, '^[A-Za-z]{3} ', ''), 'MMM d yyyy HH:mm:ss'), 'MMMM') AS month_name,  
---Revenue (one row = one sale)
    selling_price AS total_revenue,
--- Profit margin using MMR as market value
    ROUND((selling_price - mmr) / selling_price * 100, 2) AS profit_margin,
---Margin tier    
    CASE
        WHEN ((selling_price - mmr) / selling_price * 100) >= 10 THEN 'High margin'
        WHEN ((selling_price - mmr) / selling_price * 100) BETWEEN 0 AND 10 THEN 'Medium margin'
        ELSE 'Low margin'
    END AS margin_tier,

---GROUPING CARS INTO MILEAGE CATEGORIES
       CASE
           WHEN odometer < 50000 THEN 'Low Mileage'
           WHEN odometer BETWEEN 50000 AND 100000 THEN 'Moderate Mileage'
           WHEN odometer BETWEEN 100000 AND 200000 THEN 'High Mileage'
           ELSE 'Very High Mileage'
           END AS Total_Mileage,  
---GROUPING CARS INTO PRICE CATEGORIES 
       CASE 
      WHEN selling_price < 20000 THEN 'Budget cars'
      WHEN selling_price BETWEEN 20000 and 40000 THEN 'Mid-range cars'
      WHEN selling_price BETWEEN 40000 AND 70000 THEN 'Upper mid-range cars'
      ELSE 'Premium cars'
      END AS Price_Category    
FROM `brightmotor`.`default`.`car_sales_data`;
