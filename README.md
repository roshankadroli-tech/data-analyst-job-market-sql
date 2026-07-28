# data-analyst-job-market-sql
SQL analysis of the remote Data Analyst job market — ranking skills by demand and average salary to identify the most valuable skills for career growth.
# Remote Data Analyst — Skills, Demand & Salary Analysis

A SQL-based analysis of the remote Data Analyst job market, ranking skills by demand and average salary to guide career and learning decisions.

---

## Project Structure

| File | Description |
|------|-------------|
| `INTRODUCTION.md` | Project overview, motivation, and approach |
| `1_top_paying_jobs.sql` | All Data Analyst salaries in ascending order |
| `2_top_paying_job_skills.sql` | Top 10 remote jobs and their required skills |
| `3_top_demanding_skills.sql` | Most frequently requested skills overall |
| `4_top_skills_salary.sql` | Top 10 skills by average salary |
| `5_optimal_skills.sql` | Demand vs. salary combined analysis |

---

## Query Details

### `1_top_paying_jobs.sql`

**Purpose:** Lists all Data Analyst job titles and their annual salaries in ascending order.

```sql
SELECT
 job_title,
 salary_year_avg
FROM job_postings_fact
WHERE
 job_title LIKE '%Data Analyst%' AND salary_year_avg IS NOT NULL
ORDER BY
 salary_year_avg;

What it does:

Filters for any job title containing "Data Analyst"
Excludes rows with null salary values
Orders from lowest to highest salary
Insight: Gives a full view of the salary range — from entry-level to senior roles.

2_top_paying_job_skills.sql
Purpose: Creates a temporary table of the top 10 highest-paying remote Data Analyst jobs, then lists each job alongside the skills it requires.

sql
Copy
-- Step 1: Create temp table with top 10 remote jobs
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

-- Step 2: Join temp table with skills data
SELECT
 td.job_id,
 sj.skill_id,
 td.job_title,
 sd.skills
FROM top_data_analyst_jobs AS td
LEFT JOIN skills_job_dim AS sj
 ON sj.job_id = td.job_id
JOIN skills_dim AS sd
 ON sd.skill_id = sj.skill_id
ORDER BY
 salary_year_avg DESC;
What it does:

Filters for remote Data Analyst roles with non-null salaries
Joins with company_dim to include company names
Limits to the top 10 by descending salary
Then joins with skills tables to show what skills each job requires
Insight: Reveals what qualifications separate the highest earners — useful for targeting top-tier roles.

3_top_demanding_skills.sql
Purpose: Counts how often each skill appears across all Data Analyst job postings.

sql
Copy
SELECT
 skills,
 COUNT(sj.job_id) AS demand_count
FROM job_postings_fact AS td
JOIN skills_job_dim AS sj
 ON sj.job_id = td.job_id
JOIN skills_dim AS sd
 ON sd.skill_id = sj.skill_id
WHERE
 job_title_short = 'Data Analyst'
GROUP BY
 skills
ORDER BY
 demand_count DESC;
What it does:

Joins job postings → skills junction → skills dimension
Groups by skill name and counts how many job postings mention it
Orders by demand (highest first)
Insight: Answers "What do employers ask for most?" — SQL, Python, Tableau typically top the list.

4_top_skills_salary.sql
Purpose: Ranks skills by the average salary of Data Analyst jobs that require them.

sql
Copy
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
What it does:

For each skill, calculates the average salary of all Data Analyst postings that list it
Rounds to the nearest dollar
Shows only the top 10 highest-paying skills
Insight: Answers "Which skills pay the best on average?" — niche or specialized skills (e.g., Kafka, PySpark) often top this list.

5_optimal_skills.sql
Purpose: The flagship query — combines demand count and average salary into a single view for remote Data Analyst roles.

sql
Copy
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
What it does:

CTE 1 (skill_demand): Counts how many remote Data Analyst postings require each skill
CTE 2 (avg_salary): Calculates the average salary for each skill in remote roles
Final SELECT: Joins both CTEs on skill name
Sorting: Demand count first (most requested), then average salary (highest paid)
Filters applied:

job_title_short = 'Data Analyst'
job_work_from_home = 'true' (remote only)
salary_year_avg IS NOT NULL
Insight: The sweet spot — skills that are both widely requested and well-compensated. SQL, Python, and Tableau typically lead in demand, while cloud and big data tools often pay more.

Filters Applied (Across All Queries)
Filter	Value
Job title	Data Analyst (LIKE or job_title_short)
Remote	job_work_from_home = 'true' (queries 2 & 5)
Salary	salary_year_avg IS NOT NULL
How to Use
Clone this repo.
Run the SQL files against your job postings database in order.
Modify filters (e.g., location, job title) to explore other roles.
Tech Stack
SQL (PostgreSQL / MySQL compatible)
CTEs and temp tables for modular queries
Joins & aggregations for demand and salary analysis
