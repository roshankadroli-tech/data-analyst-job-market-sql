/*
Top Remote Data Analyst Jobs & Required Skills
Creates a temp table of the top 10 highest-paying remote Data Analyst roles,
then lists each job with its associated skills.
*/

DROP TABLE IF EXISTS top_data_analyst_jobs;

CREATE TABLE top_data_analyst_jobs AS
SELECT
    job_id,
	job_title,
    salary_year_avg,
    job_work_from_home,
    name AS company_name
FROM job_postings_fact AS jp
LEFT JOIN company_dim AS cd
    ON cd.company_id = jp.company_id 
WHERE
    job_title LIKE '%Data Analyst%'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = 'true'
ORDER BY 
    salary_year_avg DESC
LIMIT 10;

SElECT 
	td.job_id,
	sj.skill_id,
	td.job_title,
	sd.skills
FROM top_data_analyst_jobs AS td
LEFT JOIN skills_job_dim AS sj
	on sj.job_id = td.job_id
JOIN skills_dim AS sd
	on sd.skill_id = sj.skill_id
ORDER BY 
 	salary_year_avg DESC;

	