/* Data Analyst Skills — Ranked by Average Salary (Top 10) */

SELECT
	sd.skills,
	ROUND(AVG(jp.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact AS jp
LEFT JOIN skills_job_dim AS sj ON sj.job_id = jp.job_id
JOIN skills_dim AS sd ON sd.skill_id = sj.skill_id
WHERE
	job_title LIKE '%Data Analyst%' AND salary_year_avg IS NOT NULL
GROUP BY
	sd.skills
ORDER BY
	avg_salary DESC
LIMIT 10;