-- Create the shark_tank_data table
CREATE TABLE shark_tank_data (
    `Ep. No.` INT,
    Brand VARCHAR(255),
    Male INT,
    Female INT,
    Location VARCHAR(255),
    Idea TEXT,
    Sector VARCHAR(255),
    Deal VARCHAR(50),
    `Amount Invested lakhs` DECIMAL(10, 2),
    `Amout Asked` DECIMAL(10, 2),
    `Debt Invested` DECIMAL(10, 2),
    `Debt Asked` DECIMAL(10, 2),
    `Equity Taken %` DECIMAL(5, 2),
    `Equity Asked %` DECIMAL(5, 2),
    `Avg age` DECIMAL(5, 2),
    `Team members` INT,
    `Ashneer Amount Invested` DECIMAL(10, 2),
    `Ashneer Equity Taken %` DECIMAL(5, 2),
    `Namita Amount Invested` DECIMAL(10, 2),
    `Namita Equity Taken %` DECIMAL(5, 2),
    `Anupam Amount Invested` DECIMAL(10, 2),
    `Anupam Equity Taken %` DECIMAL(5, 2),
    `Vineeta Amount Invested` DECIMAL(10, 2),
    `Vineeta Equity Taken %` DECIMAL(5, 2),
    `Aman Amount Invested` DECIMAL(10, 2),
    `Aman Equity Taken %` DECIMAL(5, 2),
    `Peyush Amount Invested` DECIMAL(10, 2),
    `Peyush Equity Taken %` DECIMAL(5, 2),
    `Ghazal Amount Invested` DECIMAL(10, 2),
    `Ghazal Equity Taken %` DECIMAL(5, 2),
    `Total investors` INT,
    Partners VARCHAR(255)
);

-- Load data from CSV file
LOAD DATA INFILE './shark_tank_data.csv'
INTO TABLE shark_tank_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Assuming the table name is 'shark_tank_data'

-- Total episodes
SELECT MAX(`Ep. No.`) FROM shark_tank_data;
SELECT COUNT(DISTINCT `Ep. No.`) FROM shark_tank_data;

-- Pitches
SELECT COUNT(DISTINCT Brand) FROM shark_tank_data;

-- Pitches converted
SELECT 
    CAST(SUM(CASE WHEN `Amount Invested lakhs` > 0 THEN 1 ELSE 0 END) AS FLOAT) / 
    CAST(COUNT(*) AS FLOAT) AS conversion_rate
FROM shark_tank_data;

-- Total male and female
SELECT SUM(Male) AS total_male, SUM(Female) AS total_female FROM shark_tank_data;

-- Gender ratio
SELECT SUM(Female) / SUM(Male) AS gender_ratio FROM shark_tank_data;

-- Total invested amount
SELECT SUM(`Amount Invested lakhs`) AS total_invested FROM shark_tank_data;

-- Average equity taken
SELECT AVG(`Equity Taken %`) AS avg_equity_taken 
FROM shark_tank_data 
WHERE `Equity Taken %` > 0;

-- Highest deal and equity taken
SELECT MAX(`Amount Invested lakhs`) AS max_deal, 
       MAX(`Equity Taken %`) AS max_equity 
FROM shark_tank_data;

-- Startups with at least one woman
SELECT COUNT(*) AS startups_with_women 
FROM shark_tank_data 
WHERE Female > 0;

-- Pitches converted with at least one woman
SELECT COUNT(*) AS converted_pitches_with_women 
FROM shark_tank_data 
WHERE Female > 0 AND Deal != 'No Deal';

-- Average team members
SELECT AVG(`Team members`) AS avg_team_size FROM shark_tank_data;

-- Amount invested per deal
SELECT AVG(`Amount Invested lakhs`) AS avg_amount_per_deal 
FROM shark_tank_data 
WHERE Deal != 'No Deal';

-- Age group distribution
SELECT `Avg age`, COUNT(*) AS count 
FROM shark_tank_data 
GROUP BY `Avg age` 
ORDER BY count DESC;

-- Location distribution
SELECT Location, COUNT(*) AS count 
FROM shark_tank_data 
GROUP BY Location 
ORDER BY count DESC;

-- Sector distribution
SELECT Sector, COUNT(*) AS count 
FROM shark_tank_data 
GROUP BY Sector 
ORDER BY count DESC;

-- Partner deals
SELECT Partners, COUNT(*) AS count 
FROM shark_tank_data 
WHERE Partners != '-' 
GROUP BY Partners 
ORDER BY count DESC;

-- Additional queries:

-- 1. Top 5 sectors by total investment amount
SELECT Sector, SUM(`Amount Invested lakhs`) AS total_investment
FROM shark_tank_data
GROUP BY Sector
ORDER BY total_investment DESC
LIMIT 5;

-- 2. Average equity taken per sector for deals over 50 lakhs
SELECT Sector, AVG(`Equity Taken %`) AS avg_equity
FROM shark_tank_data
WHERE `Amount Invested lakhs` > 50
GROUP BY Sector
HAVING avg_equity > 0
ORDER BY avg_equity DESC;

-- 3. Deals where multiple investors participated
SELECT Brand, `Amount Invested lakhs`, 
       GROUP_CONCAT(DISTINCT 
           CASE 
               WHEN `Ashneer Amount Invested` > 0 THEN 'Ashneer'
               WHEN `Namita Amount Invested` > 0 THEN 'Namita'
               WHEN `Anupam Amount Invested` > 0 THEN 'Anupam'
               WHEN `Vineeta Amount Invested` > 0 THEN 'Vineeta'
               WHEN `Aman Amount Invested` > 0 THEN 'Aman'
               WHEN `Peyush Amount Invested` > 0 THEN 'Peyush'
               WHEN `Ghazal Amount Invested` > 0 THEN 'Ghazal'
           END
       ) AS investors
FROM shark_tank_data
WHERE Deal != 'No Deal'
GROUP BY Brand, `Amount Invested lakhs`
HAVING COUNT(DISTINCT 
           CASE 
               WHEN `Ashneer Amount Invested` > 0 THEN 'Ashneer'
               WHEN `Namita Amount Invested` > 0 THEN 'Namita'
               WHEN `Anupam Amount Invested` > 0 THEN 'Anupam'
               WHEN `Vineeta Amount Invested` > 0 THEN 'Vineeta'
               WHEN `Aman Amount Invested` > 0 THEN 'Aman'
               WHEN `Peyush Amount Invested` > 0 THEN 'Peyush'
               WHEN `Ghazal Amount Invested` > 0 THEN 'Ghazal'
           END
       ) > 1
ORDER BY `Amount Invested lakhs` DESC;

-- 4. Comparison of asked vs invested amounts by location
SELECT Location, 
       AVG(`Amout Asked`) AS avg_amount_asked,
       AVG(`Amount Invested lakhs`) AS avg_amount_invested,
       (AVG(`Amount Invested lakhs`) / AVG(`Amout Asked`)) * 100 AS investment_rate
FROM shark_tank_data
GROUP BY Location
HAVING COUNT(*) > 5
ORDER BY investment_rate DESC;

-- 5. Most active investor by number of deals
SELECT 
    CASE 
        WHEN `Ashneer Amount Invested` > 0 THEN 'Ashneer'
        WHEN `Namita Amount Invested` > 0 THEN 'Namita'
        WHEN `Anupam Amount Invested` > 0 THEN 'Anupam'
        WHEN `Vineeta Amount Invested` > 0 THEN 'Vineeta'
        WHEN `Aman Amount Invested` > 0 THEN 'Aman'
        WHEN `Peyush Amount Invested` > 0 THEN 'Peyush'
        WHEN `Ghazal Amount Invested` > 0 THEN 'Ghazal'
    END AS investor,
    COUNT(*) AS deal_count
FROM shark_tank_data
WHERE Deal != 'No Deal'
GROUP BY investor
ORDER BY deal_count DESC
LIMIT 1;