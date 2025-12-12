USE ITI
GO


-- 1.	Retrieve number of students who have a value in their age.

SELECT COUNT(St_Age)
FROM Student



-- 2.	Get all instructors Names without repetition

SELECT DISTINCT(Ins_Name)
FROM Instructor



-- 3.	Display student with the following Format (use isNull function)
--			Student ID	Student Full Name	Department name

SELECT ISNULL(St_Id, 0), 
	   CONCAT(ISNULL(St_Fname, '-'), ' ', ISNULL(St_Lname, '-')) AS [Full Name], 
	   ISNULL(D.Dept_Name, '-')
FROM Student AS S
INNER JOIN Department AS D
	ON S.Dept_Id = D.Dept_Id



-- 4.	Display instructor Name and Department Name 
--      Note: display all the instructors if they are attached to a department or not

SELECT Ins_Name, Dept_Name
FROM Instructor AS INS
LEFT JOIN Department AS D
	ON INS.Dept_Id = D.Dept_Id



-- 5.	Display student full name and the name of the course he is taking
--		For only courses which have a grade 

SELECT CONCAT(St_Fname, ' ', St_Lname) AS [Full Name],
	   C.Crs_Name
FROM Student AS S
INNER JOIN Stud_Course AS SC
	ON S.St_Id = SC.St_Id
	AND SC.Grade IS NOT NULL
INNER JOIN Course AS C
	ON SC.Crs_Id = C.Crs_Id



-- 6.	Display number of courses for each topic name


SELECT COUNT(Crs_Id), Top_Name
FROM Course AS C
INNER JOIN Topic AS T
	ON C.Top_Id = T.Top_Id
GROUP BY Top_Name



-- 7.	Display max and min salary for instructors

SELECT 
	MAX(Salary) AS [max salary], 
	MIN(Salary) AS [min salary]
FROM Instructor



-- 8.	Display instructors who have salaries less than the average salary of all instructors.

SELECT *
FROM Instructor
WHERE Salary < (SELECT AVG(Salary) FROM Instructor)



-- 9.	Display the Department name that contains the instructor who receives the minimum salary.

SELECT D.Dept_Name
FROM Department AS D
INNER JOIN Instructor AS I
	ON I.Dept_Id = D.Dept_Id
	AND Salary = (SELECT MIN(Salary) FROM Instructor)



-- Select max two salaries in instructor table.

SELECT TOP 2 Salary
FROM Instructor
ORDER BY Salary DESC

-- OR

SELECT NewTable.Salary
FROM
	(
	SELECT 
		*, 
		ROW_NUMBER() OVER(ORDER BY salary DESC) AS RN
	FROM Instructor
	) AS NewTable
WHERE NewTable.RN <= 2



-- Select instructor name and his salary but if there is no salary display instructor bonus. “use one of coalesce Function”

SELECT 
	Ins_Name,
	COALESCE(CONVERT(VARCHAR(50), salary), 'instructor bonus')
FROM Instructor



-- 12.	Select Average Salary for instructors 

SELECT AVG(Salary) AS AvgSal
FROM Instructor



-- 13.	Select Student first name and the data of his supervisor 

SELECT 
	st.St_Fname AS StudentFirstName,
	super.*
FROM Student AS st
INNER JOIN Student AS super
	ON st.St_super = super.St_Id



-- 14.	Write a query to select the highest two salaries in Each Department for instructors who have salaries. “using one of Ranking Functions”

SELECT *
FROM (
	SELECT 
		Salary,
		ROW_NUMBER() OVER(PARTITION BY Dept_id ORDER BY salary DESC) AS RN
	FROM Instructor) AS T
WHERE RN <= 2



-- 15.	 Write a query to select a random  student from each department.  “using one of Ranking Functions”

SELECT *
FROM (
	SELECT 
		*,
		ROW_NUMBER() OVER(PARTITION BY Dept_Id ORDER BY NEWID()) AS RN
	FROM Student) T
WHERE RN = 1
