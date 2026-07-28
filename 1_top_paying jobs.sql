/* Data Analyst Salaries — Ascending Order Listing */

SELECT
	job_title,
	salary_year_avg
FROM job_postings_fact
WHERE
	job_title LIKE '%Data Analyst%' AND salary_year_avg IS NOT NULL
ORDER BY 
	salary_year_avg 