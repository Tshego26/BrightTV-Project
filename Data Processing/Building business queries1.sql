-- Databricks notebook source
--Tables overview
SELECT * FROM dbo.viewership LIMIT 100;
SELECT * FROM dbo.userprofile LIMIT 100;

--Get minimum date
SELECT MIN(RecordDate) AS start_date
FROM dbo.viewership;

--Get Maximum date
SELECT MAX(RecordDate) AS End_Date
FROM dbo.viewership;

--Get min and max viewership 
SELECT MIN(Duration)
FROM dbo.viewership;

SELECT MAX(Duration)
FROM dbo.viewership;

--Get hours, minites, seconds

SELECT HOUR(Duration)
FROM dbo.viewership
WHERE HOUR(Duration);

SELECT MINUTE(Duration) 
FROM dbo.viewership;

SELECT SECOND(DURATION), duration
FROM dbo.viewership;

--South Africs is 2 hours ahead of UTC, so I am adding 2 HOURS to the Date
SELECT DATEADD(hour, 2, RecordDate) AS View_Date, RecordDate
FROM dbo.viewership
WHERE HOUR(RecordDate) = 23 AND DAY(RecordDate)=31;-- checking if its working and changes the day

--checking if I can specify hour as 3 and not 03
SELECT  HOUR(RecordDate), RecordDate
FROM dbo.viewership
WHERE HOUR(RecordDate) = 3; -- checking if its working and changes the day

--chcking for null ages
SELECT age 
FROM dbo.userprofile
WHERE age IS NULL;

--===============================================================================MINI BUSINESS QUERES=========================================================

--===========================================================================
--Which age group watches BrightTV the most?
--===========================================================================

SELECT 
COUNT(v.userID) AS Total_Number_Of_Viewers,
CASE --My age rage is between 13 and 90
WHEN u.Age IS NULL THEN 'Invalid Age'
WHEN u.Age BETWEEN 13 AND 19 THEN 'Teenagers'
WHEN u.Age BETWEEN 20 AND 35 THEN 'Young Adults'
WHEN u.Age BETWEEN 36 AND 64 THEN 'Middle Aged'
ELSE 'Senior Citizen'
END AS Age_Group
FROM dbo.viewership AS v
LEFT JOIN dbo.userprofile AS u
ON u.UserID=v.UserID
GROUP BY 
CASE --My age rage is between 13 and 90
WHEN u.Age IS NULL THEN 'Invalid Age'
WHEN u.Age BETWEEN 13 AND 19 THEN 'Teenagers'
WHEN u.Age BETWEEN 20 AND 35 THEN 'Young Adults'
WHEN u.Age BETWEEN 36 AND 64 THEN 'Middle Aged'
ELSE 'Senior Citizen'
END 
ORDER BY Total_Number_Of_Viewers DESC;

/*
Finidngs: Teenagers
--> Low registration rates
--> Possibly using parents accounts
---> Underrepresented in data but may actually watch more than data shows

Senior citizens:
-->Low tech adoption
-->Less likely to have social media or email accounts
-->May watch TV but through traditional means not tracked here

*/

--===========================================================================
--Which Gender Watches BrightTV the most
--===========================================================================

SELECT
IFNULL(u.gender, 'Empty') AS Gender,
COUNT(v.UserID) AS Total_Number_Of_Views
FROM dbo.viewership AS v
LEFT JOIN dbo.userprofile AS u
ON u.UserID=v.UserID
GROUP BY u.Gender
ORDER BY Total_Number_Of_Views DESC;

--checking how many viewers have null geders
SELECT COUNT(*) AS users_with_null_gender -- COUNT(UserID) would also work 
FROM dbo.viewership AS v
LEFT JOIN dbo.userprofile AS u
ON u.UserID = v.UserID
WHERE u.Gender IS NULL;

/*
While data shows 9x more male viewers, this may be partially attributed
to females using shared accounts. Further analysis of channel preferences
 will help determine actual content consumption patterns before making content investment decisions
 */

--===========================================================================
 --"Which race watches BrightTV the most?
--===========================================================================
SELECT 
IFNULL(u.race, 'Empty') AS Race,
COUNT(v.UserID) AS total_number_of_views
FROM dbo.viewership AS v
LEFT JOIN dbo.userprofile AS u
ON u.UserID = v.UserID
GROUP BY Race
ORDER BY total_number_of_views DESC;

 /*
 Updated SA demographics for 2016:

African/Black — 80.7%
Coloured — 8.8%
Indian/Asian — 2.5%
White — 8.1%

 Step 1 — Get total viewership:
4176 + 1564 + 1431 + 1232 + 1011 + 96 + 5 = 9,515 total views
Step 2 — Calculate each race's viewership percentage:

Black: 4176 ÷ 9515 × 100 = 43.9% of viewership
Indian Asian: 1431 ÷ 9515 × 100 = 15% of viewership

Step 3 — Compare to population percentage:
Race      Population %Viewership %Difference
Black     80.7% 43.9%     -36.8% (red)
Coloured    8.8%  16.4%+   7.6% (Green)
Indian Asian  2.5%  15%+   12.5% (Green)
White         8.1%  12.9%     +4.8% (Green)


If viewership % > population % → Overrepresented (Green)
If viewership % < population % → Underrepresented (Red)
If viewership % ≈ population % → Proportional (Good)

Black — 80.7% of population, 44% of viewership → underrepresented 
Coloured — 8.8% of population, 16% of viewership → overrepresented 
Indian Asian — 2.5% of population, 15% of viewership → massively overrepresented 
White — 8.1% of population, 13% of viewership → overrepresented 

In conclusion

Indian Asian viewers are our most engaged demographic relative to their population size,
presenting an opportunity to further invest in content targeting this group. 
Despite being 81% of the population, Black viewers are underrepresented in our viewership, 
suggesting untapped growth potential in this demographic.
*/

--===========================================================================
--Which channel gets watched the most?
--===========================================================================

SELECT 
Channel, 
COUNT(UserID) AS Total_views
FROM dbo.viewership 
GROUP BY Channel
ORDER BY Total_views DESC;


/*
Black content correlation:
-->High Black viewership + Channel O, Trace TV, MK, Africa Magic dominating = data is consistent and valid!
Female viewership theory busted:
--> E! Entertainment and Vuzu (female targeted) have LOW views = females are likely NOT using partners accounts after all!
 Your earlier theory was self-corrected with data 
Low E! and Vuzu viewership doesn't mean females aren't watching
It could mean females who DO watch prefer other content not traditionally labelled as "female"
Maybe female viewers are watching sports, music or news too!

Senior Citizens:
--> CNN viewership could represent the small senior citizen audience — news content appeals to older demographics!
M-Net:
--> Low movie/general entertainment interest among BrightTV audience

*/


--===========================================================================
--Which channel gets watched the most by gender?
--===========================================================================

SELECT 
IFNULL(u.gender, 'Empty'),
v.channel, 
COUNT(v.UserID) AS total_viewship
FROM dbo.viewership AS v
LEFT JOIN dbo.userprofile AS u
ON v.UserID=u.UserID
GROUP BY u.gender, v.channel
ORDER BY total_viewship DESC;

/*
Females:

Africa Magic, Trace TV and Cartoon Network are top female channels
NOT watching E! Entertainment and Vuzu as expected

Males:

Dominate sports as expected
But also watching E! Entertainment and Vuzu — traditionally "female" channels!

Insights 
"Contrary to expectations, female viewers on BrightTV gravitate towards Africa Magic, 
Trace TV and Cartoon Network rather than traditionally female targeted content like E! Entertainment and Vuzu. 
This suggests BrightTV's female audience has diverse content preferences that don't align with traditional gender content stereotypes

Reccomendation:
Content investment decisions should be based on actual viewing data rather than traditional gender content assumptions.
*/

--===========================================================================
--Which channel gets watched the most by race?
--===========================================================================

SELECT 
IFNULL(u.race, 'Empty') As race,
v.channel, 
COUNT(v.UserID) AS total_viewship
FROM dbo.viewership AS v
LEFT JOIN dbo.userprofile AS u
ON v.UserID=u.UserID
GROUP BY race, v.channel
ORDER BY total_viewship DESC;

/*

Indian Asian:

-->ICC Cricket World Cup is their #1 channel — cultural affinity with cricket confirmed! 
Their overrepresentation in viewership now makes even more sense!

Black viewers:

--> Channel O, Africa Magic and Trace — music and culture driven 
--> Also present in sports — SuperSport Live Events at position 4

Sports breakdown:

--> Coloured and White viewers gravitate heavily towards SuperSport
--> Black viewers surprisingly NOT the top sports watchers — Indian Asian and Coloured lead there!

The absence of football content on BrightTV may be contributing to the underrepresentation of Black viewers in sports viewership. 
Given that football is the most popular sport among Black South Africans who represent 80.7% of the population,
 adding a dedicated football channel could significantly grow viewership among this demographic

 During Q1 2016, sports content was heavily cricket dominated. A dedicated football channel or
  more football content could attract the large Black South African demographic who are underrepresented in sports viewership.
*/


--===========================================================================
--Which channel gets watched the most by age group?
--===========================================================================

SELECT 
Channel, 
CASE --My age rage is between 13 and 90
WHEN u.Age IS NULL THEN 'Invalid Age'
WHEN u.Age BETWEEN 13 AND 19 THEN 'Teenagers'
WHEN u.Age BETWEEN 20 AND 35 THEN 'Young Adults'
WHEN u.Age BETWEEN 36 AND 64 THEN 'Middle Aged'
ELSE 'Senior Citizen'
END AS Age_Group,
COUNT(v.UserID) AS Total_views
FROM dbo.viewership AS v
LEFT JOIN dbo.userprofile AS u
ON u.UserID=v.UserID
GROUP BY Channel, 
CASE --My age rage is between 13 and 90
WHEN u.Age IS NULL THEN 'Invalid Age'
WHEN u.Age BETWEEN 13 AND 19 THEN 'Teenagers'
WHEN u.Age BETWEEN 20 AND 35 THEN 'Young Adults'
WHEN u.Age BETWEEN 36 AND 64 THEN 'Middle Aged'
ELSE 'Senior Citizen'
END
ORDER BY Total_views desc;

/*
Teenagers:
-> Channel O, Trace TV and Cartoon Network — music and kids content
-> Low numbers explained by registration barriers — solid reasoning!
Young Adults:
-> Sports dominant — SuperSport and Cricket
-> Also into music channels — well rounded viewing
-> Watching Cartoon Network and Boomerang — confirms parents watching kids content OR teenagers using parents accounts! 💡
Middle Aged:
-> Similar to Young Adults but more CNN — news interest increases with age as expected!
Senior Citizens:
-> NOT on CNN as expected — surprising!
-> Small numbers — consistent with our tech adoption theory

Adults watching kids channels = teenagers using parents accounts confirmed by data!
*/

--===========================================================================
--Which month had the most viewership?
--===========================================================================

SELECT
MONTHNAME(DATEADD(hour, 2, RecordDate)) AS MonthName, 
COUNT(UserID) AS Total_Views
FROM dbo.viewership
GROUP BY MonthName
ORDER BY Total_Views DESC;

/*
"Data covers Q1 2016 (January to March) in UTC. After converting to South African Standard Time (SAST/UTC+2),
 a small number of records fall into April 2026, resulting in 4 months of data in local time.

SuperSport Live Events shows consistent organic growth across all three months, 346 in January, 500 in February and 713 in March, 
 suggesting a growing loyal sports audience independent of the Cricket surge. 
 The ICC Cricket World Cup further amplified this sports viewership in March rather than cannibalising it
*/

--March had more viewership, investigating from external sources, I can see that there was a cricket world cup that started on the 8th of march until 3 april. 
SELECT 
COUNT(UserID) AS Total_Views, MONTHNAME(DATEADD(hour, 2, RecordDate)) as month1
FROM dbo.viewership
WHERE Channel= 'ICC Cricket World Cup 2011'
GROUP BY month1;

/*
Drilling down to confrim my world cup theory, I can see that we had triple the viewership
in march for cirkcet contributing 23% of total viewership. But then what happened to the other 77%
*/

--Lest see the other 77%
SELECT COUNT(UserID) AS total_viewrship, 
MONTHNAME(DATEADD(hour, 2, RecordDate)) as month1, 
channel
FROM dbo.viewership
WHERE MONTHNAME(DATEADD(hour, 2, RecordDate))= 'Mar'
GROUP BY Channel, month1
ORDER BY total_viewrship DESC;

/*
So, this confrims my theory about cricket world cup being the biggest drive to 
more viewership in March. 

Supersports was evidently the most viewed overrall, however, 
we can see that during the workcup we had more viewership in the icc channel

results below varify
*/


SELECT COUNT(UserID) AS total_viewrship, 
MONTHNAME(DATEADD(hour, 2, RecordDate)) as month1, 
channel
FROM dbo.viewership
WHERE MONTHNAME(DATEADD(hour, 2, RecordDate))= 'Jan'
GROUP BY Channel, month1
ORDER BY total_viewrship DESC;

SELECT COUNT(UserID) AS total_viewrship, 
MONTHNAME(DATEADD(hour, 2, RecordDate)) as month1, 
channel
FROM dbo.viewership
WHERE MONTHNAME(DATEADD(hour, 2, RecordDate))= 'Feb'
GROUP BY Channel, month1
ORDER BY total_viewrship DESC;

/*
SuperSport Live Events is consistently the most watched channel in January and February.
 However in March, ICC Cricket World Cup viewership surged to #1, contributing 23% of all March views and driving an overall viewership spike.
  This suggests major sporting events significantly boost platform engagement.
*/



--===========================================================================
--Which day of the week has the most viewership?
--===========================================================================

SELECT 
DAYNAME(DATEADD(hour, 2, RecordDate)) AS Day_Of_Week,
COUNT(UserID) AS Total_views
FROM dbo.viewership
GROUP BY Day_Of_Week
ORDER BY Total_views DESC;
/*
Friday/Saturday classic weekend effect, people dont have commitment the following day so they 
can spend more time watching their favorite shows. 
Surprisingly, wednesday has ore viewership than Thursady, I was exoecting the other way around. 

Wednesday's unexpectedly high viewership warrants further investigation. 
Without additional context such as programming schedules or marketing campaigns from that period, we cannot conclusively explain this pattern
*/

--===========================================================================
--Which time slot has the most viewership?
--===========================================================================

 SELECT 
 COUNT(UserID) AS Total_Views, 
 CASE 
 WHEN HOUR(DATEADD(hour, 2, RecordDate)) BETWEEN  0 AND 5 THEN 'Midnight_To_Early_Morning'
 WHEN HOUR(DATEADD(hour, 2, RecordDate)) BETWEEN  6 AND 11 THEN 'Morning_To_Late_Morning'
 WHEN HOUR(DATEADD(hour, 2, RecordDate)) BETWEEN  12 AND 17 THEN 'Early_To_Late_Afternoon'
 WHEN HOUR(DATEADD(hour, 2, RecordDate)) BETWEEN  18 AND 20 THEN 'Early_to_Late_Evening'
 ELSE 'Night'
 END AS Daily_Hours
 FROM dbo.viewership 
 GROUP BY 
 CASE 
 WHEN HOUR(DATEADD(hour, 2, RecordDate)) BETWEEN  0 AND 5 THEN 'Midnight_To_Early_Morning'
 WHEN HOUR(DATEADD(hour, 2, RecordDate)) BETWEEN  6 AND 11 THEN 'Morning_To_Late_Morning'
 WHEN HOUR(DATEADD(hour, 2, RecordDate)) BETWEEN  12 AND 17 THEN 'Early_To_Late_Afternoon'
 WHEN HOUR(DATEADD(hour, 2, RecordDate)) BETWEEN  18 AND 20 THEN 'Early_to_Late_Evening'
 ELSE 'Night'
 END
 ORDER BY Total_Views DESC;

/*
--> Afternoon (12-17) — peak viewing at 3,560 — people watching during lunch and afternoon
--> Morning (6-11) — strong at 2,257 — before work/school viewing
-> Evening (18-20) — 1,800 — post work opportunity!
--> Night (21-23) — 1,367 — late night audience
--> Midnight (0-5) — 531 — small but loyal late night viewers

Early to Late Evening (18:00-20:00) shows 1,800 views — people are back from work and settled. 
Investing in compelling content during this time slot could push viewership from 1,800 to 2,500+

*/

--===========================================================================
--Which province has the most viewers?"
--===========================================================================
SELECT 
IFNULL(u.province, 'Empty') AS provience,
COUNT(v.UserID) AS Total_Views
FROM dbo.viewership AS v
LEFT JOIN dbo.userprofile AS u
ON u.UserID=v.UserID
GROUP BY provience
ORDER BY Total_Views DESC;

--Confirming if there are no nulls when tables are joined
SELECT 
COUNT(v.UserID) as Total_nulls
FROM dbo.viewership AS v
LEFT JOIN dbo.userprofile AS u
ON u.UserID=v.UserID
WHERE u.Province IS NULL;

/*
Gauteng dominates viewership due to higher population density, better internet access and greater social media exposure.
To grow viewership in underperforming provinces like Northern Cape and North West, BrightTV should consider targeted social media campaigns 
through regional influencers and investigate infrastructure barriers to access
*/

--===========================================================================
--Which province has the highest average viewing duration?"
--===========================================================================

SELECT 
IFNULL(u.province, 'Empty') AS Province,
ROUND(AVG
(
  HOUR(v.Duration) * 3600 +
  MINUTE(v.Duration) *60 +
  SECOND(v.Duration)
  ) / 60, 2)
AS Average_Viewing_Duration_Minutes
FROM dbo.viewership AS v
LEFT JOIN dbo.userprofile AS u
ON u.UserID=v.UserID
GROUP BY Province
ORDER BY Average_Viewing_Duration_Minutes DESC;

/*
Gauteng viewers = many but distracted 
Free State viewers = few but deeply engaged 

Option 1 — Longer content:

Free State viewers have long attention spans
They could handle full movies, long documentaries, extended sports coverage
Keep them engaged for even longer! 📺

Option 2 — More short content:

Bite sized content they can consume quickly
More episodes = more viewing events = higher viewership numbers
Think series with short episodes! 


*/

--===========================================================================
--Which channel has the most Solid Commitment / Valid Commitment viewers?
--===========================================================================


SELECT 
Channel, 
CASE 
WHEN (SECOND(v.Duration) BETWEEN 0 AND 2) AND (HOUR(v.Duration) =0 AND MINUTE(v.Duration)=0) THEN 'Clicked and Left' -- 0 secnonds to 2 seconds
WHEN SECOND(v.Duration) BETWEEN 3 AND 60 AND (HOUR(v.Duration) =0 AND MINUTE(v.Duration)=0) THEN 'Clicked and Not Commited'--3 secnds to 1 minute
WHEN MINUTE(v.Duration) >= 1 AND HOUR(v.Duration) = 0 THEN 'Casual Commitment'
WHEN HOUR(v.Duration) BETWEEN 1 AND 4 THEN 'Valid Commitment'
ELSE 'Solid Commitment'
END AS Viewership_Engagement, 
COUNT(v.UserID) AS Total_Views
FROM dbo.viewership AS v
LEFT JOIN dbo.userprofile AS u
ON u.UserID=v.UserID
GROUP BY 
Channel, 
CASE 
WHEN (SECOND(v.Duration) BETWEEN 0 AND 2) AND (HOUR(v.Duration) =0 AND MINUTE(v.Duration)=0) THEN 'Clicked and Left' -- 0 secnonds to 2 seconds
WHEN SECOND(v.Duration) BETWEEN 3 AND 60 AND (HOUR(v.Duration) =0 AND MINUTE(v.Duration)=0) THEN 'Clicked and Not Commited'--3 secnds to 1 minute
WHEN MINUTE(v.Duration) >= 1 AND HOUR(v.Duration) = 0 THEN 'Casual Commitment'
WHEN HOUR(v.Duration) BETWEEN 1 AND 4 THEN 'Valid Commitment'
ELSE 'Solid Commitment'
END
ORDER BY Total_Views DESC;

/*
While SuperSport Live Events leads in total viewership, ICC Cricket World Cup demonstrates stronger viewer loyalty 
with significantly lower 'Clicked and Left' rates. This suggests ICC Cricket viewers are more deeply engaged with the
 content compared to SuperSport viewers who may be channel surfing.
*/




--=====================================Anaysis QUERY: =========================================================


SELECT 
--WHO
IFNULL(u.Race, 'Empty') As Race, 
IFNULL(u.Gender, 'Empty') AS Gender,
CASE --My age rage is between 13 and 90
WHEN u.Age IS NULL THEN 'Invalid Age'
WHEN u.Age BETWEEN 13 AND 19 THEN 'Teenagers'
WHEN u.Age BETWEEN 20 AND 35 THEN 'Young Adults'
WHEN u.Age BETWEEN 36 AND 64 THEN 'Middle Aged'
ELSE 'Senior Citizen'
END AS Age_Group,

--WHAT
v.Channel As Channel,

--WHEN
 --DATEADD(hour, 2, v.RecordDate) AS Record_Date, 
 DATE_FORMAT(DATEADD(hour, 2, v.RecordDate), 'MMMM') AS Month_Name,
 DATE_FORMAT(DATEADD(hour, 2, v.RecordDate), 'EEEE') AS Day_Of_Week,
 CASE 
 WHEN HOUR(DATEADD(hour, 2, v.RecordDate)) BETWEEN  0 AND 5 THEN 'Midnight_To_Early_Morning'
 WHEN HOUR(DATEADD(hour, 2, v.RecordDate)) BETWEEN  6 AND 11 THEN 'Morning_To_Late_Morning'
 WHEN HOUR(DATEADD(hour, 2, v.RecordDate)) BETWEEN  12 AND 17 THEN 'Early_Afernoon_to_Late_Afternoon'
 WHEN HOUR(DATEADD(hour, 2, v.RecordDate)) BETWEEN  18 AND 20 THEN 'Early_Evening_to_Late_Evening'
 ELSE 'Night'
 END AS Daily_Hours,

--HOW LONG
ROUND(AVG
(
  HOUR(v.Duration) * 3600 +
  MINUTE(v.Duration) *60 +
  SECOND(v.Duration)
  ) / 60 , 2)
AS Average_Viewing_Duration,

CASE 
WHEN (SECOND(v.Duration) BETWEEN 0 AND 2) AND (HOUR(v.Duration) =0 AND MINUTE(v.Duration)=0) THEN 'Clicked and Left' -- 0 secnonds to 2 seconds
WHEN SECOND(v.Duration) BETWEEN 3 AND 60 AND (HOUR(v.Duration) =0 AND MINUTE(v.Duration)=0) THEN 'Clicked and Not Commited'--3 secnds to 1 minute
WHEN MINUTE(v.Duration) >= 1 AND HOUR(v.Duration) = 0 THEN 'Casual Commitment'
WHEN HOUR(v.Duration) BETWEEN 1 AND 4 THEN 'Valid Commitment'
ELSE 'Solid Commitment'
END AS Viewership_Engagement,


--WHERE
IFNULL(u.province, 'Empty') AS Province,

--Calculations
COUNT(v.UserID) AS Total_Views

FROM dbo.viewership AS v
LEFT JOIN dbo.userprofile AS u
ON v.UserID=u.UserID
GROUP BY 
 Race, 
 Gender,
 Province,
 Channel,
 Month_Name,
 Day_Of_Week, 
CASE --My age rage is between 13 and 90
WHEN u.Age IS NULL THEN 'Invalid Age'
WHEN u.Age BETWEEN 13 AND 19 THEN 'Teenagers'
WHEN u.Age BETWEEN 20 AND 35 THEN 'Young Adults'
WHEN u.Age BETWEEN 36 AND 64 THEN 'Middle Aged'
ELSE 'Senior Citizen'
END,
CASE 
 WHEN HOUR(DATEADD(hour, 2, v.RecordDate)) BETWEEN  0 AND 5 THEN 'Midnight_To_Early_Morning'
 WHEN HOUR(DATEADD(hour, 2, v.RecordDate)) BETWEEN  6 AND 11 THEN 'Morning_To_Late_Morning'
 WHEN HOUR(DATEADD(hour, 2, v.RecordDate)) BETWEEN  12 AND 17 THEN 'Early_Afernoon_to_Late_Afternoon'
 WHEN HOUR(DATEADD(hour, 2, v.RecordDate)) BETWEEN  18 AND 20 THEN 'Early_Evening_to_Late_Evening'
 ELSE 'Night'
 END, 
CASE 
WHEN (SECOND(v.Duration) BETWEEN 0 AND 2) AND (HOUR(v.Duration) =0 AND MINUTE(v.Duration)=0) THEN 'Clicked and Left' -- 0 secnonds to 2 seconds
WHEN SECOND(v.Duration) BETWEEN 3 AND 60 AND (HOUR(v.Duration) =0 AND MINUTE(v.Duration)=0) THEN 'Clicked and Not Commited'--3 secnds to 1 minute
WHEN MINUTE(v.Duration) >= 1 AND HOUR(v.Duration) = 0 THEN 'Casual Commitment'
WHEN HOUR(v.Duration) BETWEEN 1 AND 4 THEN 'Valid Commitment'
ELSE 'Solid Commitment'
END;


