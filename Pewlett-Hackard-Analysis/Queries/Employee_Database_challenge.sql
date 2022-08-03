-- Deliverable 1: The Number of Retiring Employees by Title
-- Create new table for retirement titles
SELECT e.emp_no, 
        e.first_name,
        e.last_name,
        ti.title,
        ti.from_date,
        ti.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no; 

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
        first_name,
        last_name,
        title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, to_date DESC;

--retrieve the number of employees by their most recent job title 
--who are about to retire.
SELECT COUNT (emp_no), title
INTO retiring_titles
FROM unique_titles  
GROUP BY title
ORDER BY COUNT DESC; 

-- Deliverable 2: The Employees Eligible for the Mentorship Program
-- Mentorship Eligibility table that holds the employees who are 
-- eligible to participate in a mentorship program.
SELECT DISTINCT ON (e.emp_no) e.emp_no, 
        e.first_name,
        e.last_name, 
        e.birth_date,
        de.from_date,
        de.to_date,
        ti.title
INTO mentorship_eligibilty
FROM employees as e
INNER JOIN dep_employees as de
ON e.emp_no = de.emp_no
INNER JOIN titles as ti
ON e.emp_no = ti.emp_no
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
	AND (de.to_date = '9999-01-01')
ORDER BY e.emp_no; 

-- Deliverable 3 Summary: 2 Additional Insight Tables
-- Table 1: Retirees by Department

-- Retirees by department number
-- Joining retirement_info and dept_emp tables
SELECT DISTINCT ON (ti.emp_no)
	ti.emp_no,
	ti.first_name,
	ti.last_name,
	d.dept_name,
	d.dept_no, 
	de.to_date
INTO retiring_departments
FROM unique_titles AS ti
INNER JOIN dep_employees AS de
ON ti.emp_no = de.emp_no
INNER JOIN departments as d
ON de.dept_no = d.dept_no

-- Retiree Count by Department
SELECT COUNT (rd.emp_no), rd.dept_name
-- INTO retiring_dep_count
FROM retiring_departments as rd
GROUP BY dept_name
ORDER BY COUNT DESC; 

-- Eligible Mentors by Title
SELECT COUNT (emp_no), 
	title
FROM mentorship_eligibilty
GROUP BY title
ORDER BY COUNT DESC; 

-- Eligible Mentors by Department 
SELECT COUNT (me.emp_no), 
	--de.dept_no, 
	d.dept_name
FROM mentorship_eligibilty as me
INNER JOIN dep_employees as de
ON me.emp_no = de.emp_no
INNER JOIN departments as d
ON de.dept_no = d.dept_no
GROUP BY d.dept_name, de.dept_no
ORDER BY COUNT DESC;