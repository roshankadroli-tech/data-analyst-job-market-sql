/* Most In-Demand Skills for Data Analyst Roles */

SElECT 
	skills,
	COUNT(sj.job_id) AS demand_count
FROM job_postings_fact AS td
JOIN skills_job_dim AS sj
	on sj.job_id = td.job_id
JOIN skills_dim AS sd
	on sd.skill_id = sj.skill_id
WHERE 
	job_title_short = 'Data Analyst'
GROUP BY 
	skills
ORDER BY 
	demand_count DESC;