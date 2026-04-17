-- Databricks notebook source
-- Preview the tables
SELECT * FROM dbo.userprofile LIMIT 100;

--Check if all data is uploaded
SELECT COUNT(UserID) FROM dbo.userprofile;
SELECT COUNT(UserID) FROM dbo.viewership;

--Check Columns and Data types
DESCRIBE dbo.userprofile;

-- Find duplicate users (users appearing more than once)
SELECT COUNT(*) as totalusers, UserID
FROM dbo.userprofile
GROUP BY UserID
HAVING COUNT(*) > 1; -- > 1, not > 0


/*
====================================================================================================DATA CLEANING===============================================================================
Fix space characters first (Trim-first and last cahrater spaces) — convert to true nulls
Then handle missing/null values — now we can trust our null counts
Then fix invalid ages — replace with null
Then handle "Break in transmission" — exclude from analysis
Then investigate duplicate UserID columns — decide which to keep

*/

--Gender
SELECT COUNT(Gender)
FROM dbo.userprofile
WHERE Gender =' ';

--check true nulls
SELECT COUNT(Gender)
FROM dbo.userprofile
WHERE Gender IS NULL;

--Check false null values
SELECT COUNT(*) 
FROM  dbo.userprofile
WHERE TRIM(Gender) = '';

--Set Gender and make it a true null
Update dbo.userprofile
SET Gender = NULL 
WHERE TRIM(Gender) = '';

--Verify that the update worked
SELECT COUNT(*) AS total_rows,
COUNT(gender) AS rows_with_gender,
COUNT(*) - COUNT(gender) AS null_genders
FROM dbo.userprofile;

--race
SELECT COUNT(race)
FROM dbo.userprofile
WHERE race= ' ';

--check true nulls
SELECT count(race)
FROM dbo.userprofile
WHERE race IS NULL;

--Check false null values
SELECT COUNT(race)
FROM dbo.userprofile
WHERE TRIM(race)='';

--Set race and make it a true null
Update dbo.userprofile
SET race = NULL 
WHERE TRIM(race) = '';

--Verify that the update worked:
SELECT 
COUNT(*) as total_rows,
COUNT(Race) as rows_with_race,
COUNT(*) - COUNT(Race) as rows_with_nulls
FROM dbo.userprofile;

--Province
SELECT COUNT(Province)
FROM dbo.userprofile
WHERE Province =' ';

--check true nulls
SELECT COUNT(Province)
FROM dbo.userprofile
WHERE Province IS NULL;

--Check false null values
SELECT COUNT(*) 
FROM  dbo.userprofile
WHERE TRIM(Province) = '';

--Set Province and make it a true null
Update dbo.userprofile
SET Province = NULL 
WHERE TRIM(Province) = '';

--Verify that the update worked
SELECT COUNT(*) AS total_rows,
      COUNT(Province) AS rows_with_provience, 
      COUNT(*) - COUNT(Province) AS rows_with_nulls
FROM dbo.userprofile;

--Check for a valid age range

SELECT Count(age) 
FROM dbo.userprofile
WHERE age BETWEEN 13 AND 90;

--check for invaid age range
SELECT Count(age) --696
FROM dbo.userprofile
WHERE NOT age BETWEEN 13 AND 90;

--Now that we have identified invalid age, we can replace the invalid age with null

UPDATE dbo.userprofile
SET age = NULL 
WHERE NOT age BETWEEN 13 AND 90;

--Verify if the upate worked
SELECT 
COUNT(*) as total_rows,
COUNT(age) AS rows_with_age, 
COUNT(*) - COUNT(age) AS rows_with_nulls
FROM dbo.userprofile;

--============================================Standardise User profile: check for unique first==================================================

--Check province
SELECT DISTINCT Province
FROM dbo.userprofile;

--Check Gender
SELECT DISTINCT Gender
FROM dbo.userprofile;

--Check race
SELECT DISTINCT race
FROM dbo.userprofile;

--========================Now we Standardise===========================

--Gender
UPDATE dbo.userprofile
Set Gender= INITCAP(Gender)
WHERE Gender= 'male' OR gender= 'female';

--Race
UPDATE dbo.userprofile
Set race= INITCAP(race)
WHERE race= 'black' OR race= 'white' OR race = 'coloured' OR race='indian_asian' OR race= 'other';

--We need to ensure that inisan asian maintains consistency
UPDATE dbo.userprofile
SET race= REPLACE(race, '_', ' ')
WHERE race= 'Indian_asian';

UPDATE dbo.userprofile
Set race= INITCAP(race)
WHERE race='Indian asian';

--==================Now I want to make the None value readable=============================
UPDATE dbo.userprofile
SET Gender= 'Not Specified'
WHERE Gender= 'None';

UPDATE dbo.userprofile
SET race= 'Not Specified'
WHERE race= 'None';

UPDATE dbo.userprofile
SET Province= 'Not Specified'
WHERE Province= 'None';



