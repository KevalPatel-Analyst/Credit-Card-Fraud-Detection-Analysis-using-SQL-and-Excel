create database creditcard_db;
use creditcard_db;

select * from creditcard;

-- Total transaction, fraud transaction and fraud rate.
Select Count(*) As TotalTransactions,
sum(case when class = 1 then 1 else 0 end) as FraudTransactions,
round((sum(case when class = 1 then 1 else 0 end)*100)/ Count(*),2) as FraudRate
from creditcard_db.creditcard
where class is not null;

-- What is the total value lost to fraud?
select 
round(sum(case when class = 1 then Amount else 0 end),0) as FraudAmount,
round(sum(case when class = 0 then Amount else 0 end),0) as LegitAmount,
round(sum(Amount),0) as TotalAmount
from creditcard_db.creditcard;

-- When does fraud happen the most?
select
Floor(Time/3600) % 24 as HoursOfDay,
Count(*) As TotalTransactions,
sum(case when class = 1 then 1 else 0 end) as FraudTransactions,
round((sum(case when class = 1 then 1 else 0 end)*100)/ Count(*),2) as FraudRate
from creditcard_db.creditcard
group by HoursOfDay
order by HoursOfDay;

-- Does fraud happen more in high-value transactions?
Select 
	Case
		When Amount <10 then "Low(<10)"
        when Amount between 10 and 100 then "Medium(>10,<100)"
        when Amount >100 then "High(>100"
	End as AmountCategory,
	Count(*) As TotalTransactions,
	sum(case when class = 1 then 1 else 0 end) as FraudTransactions,
	round((sum(case when class = 1 then 1 else 0 end)*100)/ Count(*),2) as FraudRate
from creditcard_db.creditcard
group by AmountCategory
order by FraudRate desc;

--  Number of fraud vs legit transactions over hours
Select floor(time / 3600)% 24 as hours,
round(sum(case when class = 1 then 1 else 0 end),0) as Fraud,
round(sum(case when class = 0 then 1 else 0 end),0) as Legit
from creditcard_db.creditcard
group by hours;



SELECT RiskFlag, 
       COUNT(*) AS Transactions,
       SUM(CASE WHEN Class=1 THEN 1 ELSE 0 END) AS FraudCount
FROM (
   SELECT 
       Time,
       Amount,
       Class,
       FLOOR(Time / 3600) % 24 AS HourOfDay,
       CASE 
           WHEN Amount > 2000 THEN 'Very High Value(>2000)'
           WHEN Amount > 500 AND ((Time / 3600) % 24 BETWEEN 0 AND 5) THEN 'High Risk (Odd Hour(0-5),>500)'
           WHEN Amount > 500 THEN 'High Value(>500)'
           ELSE 'Normal(<500)'
       END AS RiskFlag
   FROM creditcard_db.creditcard
) AS RiskTable
GROUP BY RiskFlag
ORDER BY Transactions DESC;

-- Risk Flag
SELECT 
    -- Time,
    FLOOR(Time / 86400) + 1 AS DayNumber, 
    floor(Time / 3600) % 24 AS HourOfDay,
    Amount,
    Class,
    CASE 
        WHEN Amount > 2000 THEN 'Very High Value'
        WHEN Amount > 500 AND ((Time / 3600) % 24 BETWEEN 0 AND 5) THEN 'High Risk (Odd Hour)'
        WHEN Amount > 500 THEN 'High Value'
        ELSE 'Normal'
    END AS RiskFlag
FROM creditcard_db.creditcard
WHERE Class = 1
ORDER BY Amount DESC;



SELECT 
    -- Time,
    FLOOR(Time / 86400) + 1 AS DayNumber, 
    floor(Time / 3600) % 24 AS HourOfDay,
    Amount,
    Class,
    CASE 
        WHEN Amount > 2000 THEN 'Very High Value'
        WHEN Amount > 500 AND ((Time / 3600) % 24 BETWEEN 0 AND 5) THEN 'High Risk (Odd Hour)'
        WHEN Amount > 500 THEN 'High Value'
        ELSE 'Normal'
    END AS RiskFlag
FROM creditcard_db.creditcard
ORDER BY Amount DESC;





















