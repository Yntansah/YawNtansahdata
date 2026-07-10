CREATE TABLE hr_data (
    employee_id       INT PRIMARY KEY,
    first_name        VARCHAR(50),
    last_name         VARCHAR(50),
    gender            VARCHAR(10),
    age               INT,
    department        VARCHAR(50),
    job_role          VARCHAR(50),
    education         VARCHAR(20),
    marital_status    VARCHAR(20),
    salary            INT,
    years_at_company  INT,
    years_in_role     INT,
    performance_rating INT,
    job_satisfaction  INT,
    work_life_balance INT,
    overtime          VARCHAR(5),
    attrition         VARCHAR(5),
    hire_date         DATE,
    exit_date         DATE
);

-- counting number of employees before attrition
SELECT COUNT(*) AS  total_num
FROM hr_data
-- counting number of employees after attrition
SELECT COUNT(*) AS  total_remaining
FROM hr_data
where attrition = 'No'

-- counting the number of employees that have left the company
SELECT COUNT(*) AS  total_left
FROM hr_data
where attrition = 'Yes'

-- checking the average salary of employees per department before attrition
SELECT department,
		round(avg(salary),2) as avg_salary,
		round(coalesce (avg(salary) filter(where attrition ='No'),0),2) as avg_salary_remaining,
		round(coalesce (avg(salary) filter(where attrition = 'Yes'),0),2) as avg_salary_left	
FROM hr_data
GROUP BY department
ORDER BY avg_salary desc



-- counting exit employees per department
SELECT department, 
	   COUNT(*) AS totalExit 
FROM hr_data
WHERE exit_date IS NOT NULL
group by department
order by totalExit desc


SELECT department, 
	   COUNT(*) AS totalExit 
FROM hr_data
WHERE exit_date IS NULL
group by department
order by totalExit desc

--employees per department 
SELECT
    department,
    COUNT(*) AS total_employees
FROM hr_data
WHERE attrition = 'No'
GROUP BY department
ORDER BY total_employees DESC;


--gender breakdown of attrition rate
SELECT gender,
		count(*) as totalcount,
		ROUND(count(*) * 100 / sum(count(*)) over(),1) gendercount
from hr_data 
WHERE exit_date is not null
group by gender

--gender breakdown of employees
SELECT gender,
		count(*) as totalcount,
		ROUND(count(*) * 100 / sum(count(*)) over(),1) gendercount
from hr_data 
WHERE exit_date is null
group by gender

--gender split per department
SELECT
    department,
	 COUNT(*) AS total,
    COUNT(*) FILTER (WHERE gender = 'Male')   AS male_count,
    COUNT(*) FILTER (WHERE gender = 'Female') AS female_count  
FROM hr_data
WHERE attrition = 'No'
GROUP BY department
ORDER BY total DESC;



--gender split per department
SELECT  department,
		count(*) as totalcount,
		count(*) FILTER (WHERE gender = 'Male') as malecount,
		count(*) FILTER (WHERE gender = 'Female') as femalecount
from hr_data
where attrition = 'No' 
group by department 
ORDER BY totalcount desc

--average age per department
SELECT department,
		ROUND(avg(age),0) as avg_age,
		min(age) as min_age,
		max(age) as max_age
FROM hr_data
WHERE attrition ='No' 
GROUP BY department

--attrition rate

SELECT COUNT(*) AS totalnum,
	   COUNT(*) FILTER(WHERE attrition = 'Yes') AS total_left,
	   ROUND(COUNT(*) FILTER(WHERE attrition = 'Yes') * 100/ COUNT(*),1) AS PTC_LEFT
FROM hr_data

--department with highest attrition rate
SELECT department,
		COUNT(*) FILTER(WHERE attrition ='Yes') AS total_left,
		ROUND(
        COUNT(*) FILTER (WHERE attrition = 'Yes') * 100.0 / COUNT(*),
    1)||'%' AS attrition_rate_pct
FROM  hr_data
GROUP BY department
ORDER BY total_left desc

-- checking if overtime correlate with attrition

SELECT overtime,
		count(*) as total_count,
		count(*) filter(where attrition ='Yes') as left_count,
		round(count(*) filter(where attrition ='Yes')*100 / count(*),1) as attrition_pct
FROM hr_data
GROUP BY overtime

-- average tenure of employees who left or stayed
SELECT attrition,
		round(avg(years_at_company),1) as years_spent_at_company,
		round(avg(years_in_role),1) as years_spent_in_role
FROM hr_data
GROUP BY attrition

-- checking the max and min salary per depart
SELECT department,
		max(salary) as max_salary,
		min(salary) as min_salary,
		ROUND(avg(salary),0) as avg_salary
FROM hr_data
where exit_date IS NULL
GROUP BY department

--NUMBER OF MALES AND FEMALES IN THE COMPANY
SELECT gender,
		count(*) FILTER(WHERE attrition = 'No') gender_count
FROM hr_data
GROUP BY gender


--NUMBER OF MALES AND FEMALES THAT HAVE LEFT THE COMPANY
SELECT gender,
		count(*) FILTER(WHERE attrition = 'Yes') gender_count
FROM hr_data
GROUP BY gender
-- checking marital status of employees
SELECT gender, marital_status,
		COUNT(*) FILTER(WHERE attrition ='No') as num_marriage
FROM hr_data
GROUP BY gender, marital_status

--department with highest salary payment
SELECT department,
	   sum(salary) as total_payment
FROM hr_data
WHERE attrition = 'No'
GROUP BY  department
ORDER BY total_payment desc

--average job satisfaction scores between those that have left and those remaining in the company
SELECT attrition,
		ROUND(avg(job_satisfaction),2) avg_job_satisfaction,
		ROUND(avg(work_life_balance),2) avg_work_balance,
		ROUND(avg(performance_rating),2) avg_performance_rating
FROM hr_data
GROUP BY attrition

--age bracket where attrition starts

SELECT 
	  CASE 
	  	  WHEN age BETWEEN 20 AND 29 THEN '20-29'
		  WHEN age BETWEEN 30 AND 39 THEN '30-39'
		  WHEN age BETWEEN 40 AND 49 THEN '40-49'
		  ELSE 'ABOVE 49'
	  END AS age_category,
	  COUNT(*) AS total_count,
	  COUNT(*) FILTER (WHERE  attrition = 'Yes') AS attrition_count,
	  ROUND(COUNT(*) FILTER (WHERE  attrition = 'Yes') * 100 /COUNT(*),2) || '%' AS attrition_pct
FROM hr_data
GROUP BY age_category
ORDER BY attrition_pct desc

--AVG SALARY PER DEPARTMENT
SELECT department,
		ROUND(AVG(salary),0) AS avg_salary,
		MAX(salary) AS max_salary,
		MIN(salary) AS min_salary
FROM hr_data
WHERE attrition = 'No'
GROUP BY department

--HOW SALARY DIFFER BY GENDER PER DEPARTMENT
SELECT gender,department,
		ROUND(AVG(salary),0) AS avg_salary,
		MAX(salary) AS max_salary,
		MIN(salary) AS min_salary
FROM hr_data
WHERE attrition = 'No'
GROUP BY department, gender

-- salary by education level of education
SELECT education,
		round(avg(salary) filter (where attrition = 'No'),2) as total_salary,
		COUNT(*) AS total_employee
FROM hr_data
group by education
order by total_salary desc

-- employees at performance rating level


SELECT performance_rating,
		COUNT(*) FILTER(WHERE attrition = 'No')as total_count,
		ROUND(COUNT(*) * 100/SUM(COUNT(*)) OVER(),2) AS percentage
FROM hr_data
WHERE attrition = 'No' 
GROUP BY performance_rating
ORDER BY performance_rating

--checking the number of hire per year
SELECT EXTRACT (YEAR FROM hire_date) as year,
	   COUNT(*) AS hire_year_num
FROM hr_data
GROUP BY EXTRACT (YEAR FROM hire_date)
ORDER BY COUNT(*) desc


-- attrition per year
SELECT EXTRACT (YEAR FROM hire_date) as year,
	   COUNT(*)FILTER(WHERE attrition = 'Yes') AS attrition_year_num
FROM hr_data
GROUP BY EXTRACT (YEAR FROM hire_date)
ORDER BY COUNT(*)FILTER(WHERE attrition = 'Yes') desc


-- department with highest job satisfaction

SELECT
    department,
    ROUND(AVG(job_satisfaction) filter(WHERE attrition = 'No'), 2) AS avg_satisfaction
FROM hr_data

GROUP BY department
ORDER BY avg_satisfaction DESC;
-- checking the correlation between hig performers and salary	
SELECT
    performance_rating,
    ROUND(AVG(salary), 0) AS avg_salary,
    COUNT(*)   AS totalcount
FROM hr_data
WHERE attrition = 'No'
GROUP BY performance_rating
ORDER BY performance_rating DESC;	 


--creating report on active employees
CREATE VIEW active_employees_report AS(
SELECT	employee_id,
		CONCAT(first_name,' ',last_name) AS full_name,
		gender,
		age,
CASE 
	WHEN age BETWEEN 20 AND 29 THEN 'YOUNG AGE'
	WHEN age BETWEEN 30 AND 39 THEN 'MID AGE'
	WHEN age BETWEEN 40 AND 49 THEN 'OLD AGE'
	ELSE 'ELDERLY'
END AS age_category,
		department,
		job_role,
		education,
		marital_status,
		salary,
CASE 
	WHEN salary < 40000 THEN 'Starter'
	WHEN salary < 65000 THEN 'Medium'
	WHEN salary < 90000 THEN 'Senior'
	ELSE 'Executive'
END AS salary_band,
		years_at_company,
		years_in_role,
		performance_rating,
		job_satisfaction,
CASE
	WHEN job_satisfaction >= 4 THEN 'High'
	WHEN job_satisfaction = 3 THEN 'Medium'
	ELSE 'Low'
END AS satisfactory_band,
		work_life_balance,
		overtime,
		hire_date
FROM hr_data
WHERE attrition = 'No'
	
)












