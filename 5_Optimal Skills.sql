/*
Remote Data Analyst Skills — Demand vs. Salary Analysis
Purpose: Identify the most in-demand skills for remote Data Analyst roles
 and compare them against average salaries.
Filters: Remote jobs (work_from_home = 'true'), non-null salaries.
Output: Each skill's demand count and average salary, sorted by demand
 (highest first), then by salary (highest first).
*/

WITH skill_demand AS (
 SELECT
 sd.skills,
 COUNT(sj.job_id) AS demand_count
 FROM job_postings_fact AS jd
 JOIN skills_job_dim AS sj ON sj.job_id = jd.job_id
 JOIN skills_dim AS sd ON sd.skill_id = sj.skill_id
 WHERE
 job_title_short = 'Data Analyst'
 AND salary_year_avg IS NOT NULL
 AND job_work_from_home = 'true'
 GROUP BY sd.skills
),
avg_salary AS (
 SELECT
 sd.skills,
 ROUND(AVG(jp.salary_year_avg), 0) AS avg_salary
 FROM job_postings_fact AS jp
 LEFT JOIN skills_job_dim AS sj ON sj.job_id = jp.job_id
 JOIN skills_dim AS sd ON sd.skill_id = sj.skill_id
 WHERE
 job_title_short = 'Data Analyst'
 AND salary_year_avg IS NOT NULL
 AND job_work_from_home = 'true'
 GROUP BY sd.skills
)
SELECT
 sd.skills,
 sd.demand_count,
 sa.avg_salary
FROM skill_demand sd
JOIN avg_salary sa ON sd.skills = sa.skills
ORDER BY sd.demand_count DESC, sa.avg_salary DESC;