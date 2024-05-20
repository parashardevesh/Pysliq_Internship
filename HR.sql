-- Q-1 Total number of employees in the dataset.
SELECT COUNT(*) AS total_employees
FROM general;

-- Q-2 List all unique job roles in the dataset.
SELECT DISTINCT jobrole AS unique_jobroles
FROM general;

-- Q-3 Find the average age of employees.
SELECT ROUND(AVG(age), 2) as emp_average_age
FROM general;

-- Q-4 Retrieve the names and ages of employees who have worked at the company for more
-- than 5 years.
SELECT "Emp Name" as emp_name, age, yearsatcompany
FROM general
WHERE yearsatcompany>5
ORDER BY emp_name;

-- Q-5 Get a count of employees grouped by their department.
SELECT department, COUNT(*) as emp_count
FROM general
GROUP BY department
ORDER BY emp_count;

-- Q-6 List employees who have 'High' Job Satisfaction.
SELECT "Emp Name" as employees_with_high_job_satisfaction
FROM general AS g 
LEFT JOIN empsurvey AS e
ON g.employeeid = e.employeeid
WHERE e.jobsatisfaction in ('3', '4'); 

-- Q-7  Find the highest Monthly Income in the dataset.
SELECT "Emp Name", monthlyincome AS highest_monthly_income
FROM general
WHERE monthlyincome = (SELECT max(monthlyincome)
                    FROM general);

-- Q-8  List employees who have 'Travel_Rarely' as their BusinessTravel type.
SELECT "Emp Name" AS emp_name
FROM general
WHERE businesstravel = 'Travel_Rarely';

-- Q-9 Retrieve the distinct MaritalStatus categories in the dataset.
SELECT DISTINCT MaritalStatus
FROM general;

--Q-10 Get a list of employees with more than 2 years of work experience but less than 4 years in
-- their current role.
SELECT employeeid, 
    "Emp Name" AS emp_with3yrs_WorkEx, 
    jobrole
FROM general
WHERE yearsatcompany = 3
GROUP BY jobrole, "Emp Name", employeeid
ORDER BY employeeid; 

-- Q-11 List employees who have changed their job roles within the company (JobLevel and
-- JobRole differ from their previous job).
SELECT EmployeeID, "Emp Name",
    CurrentJobRole, PreviousJobRole, 
    CurrentJobLevel, PreviousJobLevel
FROM (
    SELECT EmployeeID, "Emp Name",
        JobRole AS CurrentJobRole, JobLevel AS CurrentJobLevel,
        LAG(JobRole ) OVER(PARTITION BY EmployeeID ORDER BY YearsAtCompany) AS PreviousJobRole, 
        LAG(JobLevel) OVER(PARTITION BY EmployeeID ORDER BY YearsAtCompany) AS PreviousJobLevel
        FROM general
) AS JobChanges
WHERE (CurrentJobRole != PreviousJobRole)
OR (CurrentJobLevel != PreviousJobLevel);


-- Q-12 Find the average distance from home for employees in each department.
SELECT department, 
    ROUND(AVG(distancefromhome),2) AS avg_distance_from_home
FROM general
GROUP BY department
ORDER BY avg_distance_from_home;

-- Q-13 Retrieve the top 5 employees with the highest MonthlyIncome.
WITH top_5_income AS (
    SELECT *, 
        ROW_NUMBER() OVER(ORDER BY monthlyincome DESC) AS rn
    FROM general
)
SELECT "Emp Name", MonthlyIncome
FROM top_5_income
WHERE rn<=5; 

-- Q-14 Calculate the percentage of employees who have had a promotion in the last year.
SELECT ROUND(100*(
    SELECT COUNT(*)
    FROM general
    WHERE yearssincelastpromotion = 1
)/CAST(COUNT(*) AS numeric), 2) AS percentage_emp_last_year_promotion
FROM general; 

-- Q-15 List the employees with the highest and lowest EnvironmentSatisfaction.
SELECT g.employeeid, "Emp Name", e.environmentsatisfaction
FROM general AS g
JOIN empsurvey AS e 
ON g.employeeid = e.employeeid
WHERE e.environmentsatisfaction IN (
    SELECT MAX(environmentsatisfaction)
    FROM empsurvey
    WHERE environmentsatisfaction != 'NA'
    UNION
    SELECT MIN(environmentsatisfaction)
    FROM empsurvey
);


-- Q-16 Find the employees who have the same JobRole and MaritalStatus.
SELECT e1.employeeid AS empId, e1."Emp Name",
    e1.JobRole, 
    e1.MaritalStatus
FROM general e1
INNER JOIN general e2 ON e1.employeeid < e2.employeeid
            AND e1.JobRole = e2.JobRole
            AND e1.MaritalStatus = e2.MaritalStatus
GROUP BY empId, e1."Emp Name", 
    e1.JobRole, e1.MaritalStatus
HAVING COUNT(*) > 1
ORDER BY JobRole, MaritalStatus;
   


-- Q-17 List the employees with the highest TotalWorkingYears who also have a
-- PerformanceRating of 4.
SELECT g."Emp Name", m.performancerating, g.totalworkingyears
FROM general AS g
LEFT JOIN managersurvey as m
ON g.employeeid = m.employeeid
WHERE m.performancerating='4'
AND g.totalworkingyears = (
    SELECT MAX(totalworkingyears)
    FROM general
    WHERE employeeid IN (
        SELECT employeeid
        FROM managersurvey
        WHERE performancerating = '4'
    )
) 
ORDER BY totalworkingyears DESC; 


--Q-18 Calculate the average Age and JobSatisfaction for each BusinessTravel type.
SELECT g.businesstravel, ROUND(AVG(g.age), 2) as avg_age,
    ROUND(AVG(
        CASE WHEN e.jobsatisfaction IS NULL OR e.jobsatisfaction = 'NA' 
        THEN 0 
        ELSE CAST(e.jobsatisfaction AS NUMERIC)
        END
        ), 2) AS avg_jobsatisfaction
FROM general AS g   
LEFT JOIN empsurvey AS e
ON g.employeeid = e.employeeid
GROUP BY g.businesstravel; 

-- Q-19  Retrieve the most common EducationField among employees.
SELECT EducationField AS mostCommon_EducationField, 
    COUNT(*) AS Frequency
FROM general
GROUP BY educationfield
ORDER BY Frequency DESC
LIMIT 1;

-- Q-20 List the employees who have worked for the company the longest but haven't had a
-- promotion.
SELECT "Emp Name", yearsatcompany, yearssincelastpromotion
FROM general
WHERE yearssincelastpromotion = 0 AND 
yearsatcompany = (
    SELECT max(yearsatcompany) 
    FROM general
);