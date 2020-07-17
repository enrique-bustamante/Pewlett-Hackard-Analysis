--create a list of employees with their titles and salaries
SELECT ei.emp_no,
    ei.first_name,
    ei.last_name,
    t.title,
    t.from_date,
    t.to_date,
    s.salary
INTO joined_emp_title_salary_info
FROM emp_info AS ei
    INNER JOIN titles AS t
        ON (ei.emp_no = t.emp_no)
    INNER JOIN salaries AS s
        ON (ei.emp_no = s.emp_no)
;

--
SELECT emp_no,
    first_name,
    last_name,
    title,
    from_date,
    salary
INTO retirement_emp_title_list
FROM
 (SELECT emp_no,
    first_name,
    last_name,
    title,
    from_date,
    salary, ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY to_date DESC) rn
 FROM joined_emp_title_salary_info
 ) tmp WHERE rn = 1
ORDER BY emp_no;

--count of total titles
SELECT COUNT(emp_no)
INTO title_count
FROM retirement_emp_title_list;

--count of employees set for retirement by title
SELECT title,
    COUNT(emp_no)
INTO emp_count_by_title
FROM retirement_emp_title_list
GROUP BY title;

--Create a table for the Mentorship program
SELECT
    e.emp_no,
    e.first_name,
    e.last_name,
    ti.title,
    de.from_date,
    de.to_date
INTO mentorship_list_challenge
FROM employees AS e
    INNER JOIN dept_emp AS de
        ON (e.emp_no = de.emp_no)
    INNER JOIN titles AS ti
        ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND de.to_date = '9999-01-01'
AND ti.to_date = '9999-01-01';

--A more efficient way of creating the list
SELECT
    e.emp_no,
    e.first_name,
    e.last_name,
    t.title,
    t.from_date,
    t.to_date
INTO mentorship_list
FROM employees AS e
    INNER JOIN titles AS t
        ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND t.to_date = '9999-01-01';
