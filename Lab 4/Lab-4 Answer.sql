USE Company_SD
GO


-- 1.	Display (Using Union Function)
-- a.	The name and the gender of the dependence that's gender is Female and depending on Female Employee.
-- b.	 And the male dependence that depends on Male Employee.

SELECT D.Dependent_name, D.Sex
FROM Dependent AS D
INNER JOIN Employee AS E
	ON D.ESSN = E.SSN
WHERE D.Sex = E.Sex

UNION

SELECT D.Dependent_name, D.Sex
FROM Dependent AS D
INNER JOIN Employee AS E
	ON D.ESSN = E.SSN
WHERE D.Sex = E.Sex



-- 2.	For each project, list the project name and the total hours per week (for all employees) spent on that project.

SELECT Pname, SUM(W.Hours)
FROM Project AS P
INNER JOIN Works_for AS W
	ON P.Pnumber = W.Pno
GROUP BY Pname



-- 3.	Display the data of the department which has the smallest employee ID over all employees' ID.

SELECT D.*
FROM Departments AS D
INNER JOIN Employee AS E
	ON D.Dnum = E.Dno
WHERE E.SSN = (SELECT MIN(SSN) FROM Employee)



-- 4.	For each department, retrieve the department name and the maximum, minimum and average salary of its employees.

SELECT 
	D.Dname,
	MAX(E.Salary) AS [Max Salary],
	MIN(E.Salary) AS [Min Salary],
	AVG(E.Salary) AS [Avg Salary]
FROM Employee AS E
INNER JOIN Departments AS D
	ON E.Dno = D.Dnum
GROUP BY D.Dname



-- 5.	List the last name of all managers who have no dependents.

SELECT Lname
FROM Employee AS E
INNER JOIN Departments AS D
	ON E.SSN = D.MGRSSN AND NOT EXISTS (
		SELECT 1
		FROM Dependent
		WHERE D.MGRSSN = ESSN
	)



-- 6.	For each department-- if its average salary is less than the average salary of all employees-- display its number, name and number of its employees.

SELECT 
	D.Dnum, 
	D.Dname, 
	COUNT(E.SSN), 
	AVG(E.Salary)
FROM Employee AS E 
INNER JOIN Departments AS D
	ON E.Dno = D.Dnum
GROUP BY D.Dname, D.Dnum
HAVING AVG(E.Salary) < (SELECT AVG(Salary) FROM Employee)



-- 7.	Retrieve a list of employees and the projects they are working on ordered by department and within each department, ordered alphabetically by last name, first name.

SELECT 
	CONCAT(E.Fname, ' ', E.Lname) AS [Employee Name],
	P.Pname AS [Project Name],
	D.Dname AS [Department Name]
FROM Employee AS E
INNER JOIN Works_for AS W
	ON E.SSN = W.ESSn
INNER JOIN Project AS P
	ON W.Pno = P.Pnumber
INNER JOIN Departments AS D
	ON P.Dnum = D.Dnum
ORDER BY D.Dname, E.Lname, E.Fname ASC



-- 8.	Try to get the max 2 salaries using subquery

SELECT Salary
FROM Employee
WHERE Salary IN (
	(SELECT MAX(Salary) FROM Employee),
	(SELECT MAX(Salary) FROM Employee WHERE Salary < (SELECT MAX(Salary) FROM Employee))
)
ORDER BY Salary DESC



-- 9.	Get the full name of employees that is similar to any dependent name

SELECT CONCAT(Fname, ' ', Lname) AS Name
FROM Employee
WHERE CONCAT(Fname, ' ', Lname) IN (SELECT Dependent_name FROM Dependent)



-- 10.	Display the employee number and name if at least one of them have dependents (use exists keyword)

SELECT 
	CONCAT(E.Fname, ' ', E.Lname) [Full Name], 
	E.SSN
FROM Employee AS E
WHERE EXISTS (SELECT 1 FROM Dependent AS D WHERE E.SSN = D.ESSN)




-- DML
/* 1.	In the department table insert new department 
		called "DEPT IT", 
		with id 100, 
		employee with SSN = 112233 as a manager for this department. 
		The start date for this manager is '1-11-2006'
*/
 INSERT INTO Departments
	VALUES('DEPT IT', 100, 112233, '1-11-2006')



/* 2.	Do what is required if you know that : 
			Mrs.Noha Mohamed(SSN=968574) moved to be the manager of the new department (id = 100), 
			and they give you(your SSN =102672) her position (Dept. 20 manager) 

a.	First try to update her record in the department table
b.	Update your record to be department 20 manager.
c.	Update the data of employee number=102660 to be in your teamwork (he will be supervised by you) (your SSN =102672)
*/

UPDATE Departments
	SET MGRSSN = 968574,
		[MGRStart Date] = GETDATE()
	WHERE Dnum = 100

UPDATE Departments
	SET MGRSSN = 102672,
		[MGRStart Date] = GETDATE()
	WHERE Dnum = 20

UPDATE Employee
	SET Dno = 100,
		Superssn = 968574
	WHERE SSN = 968574

UPDATE Employee
	SET Dno = 20,
		Superssn = 102672
	WHERE SSN = 102672


UPDATE Employee
	SET Superssn = 102672,
		Dno = 20
	WHERE SSN = 102660



/* 3.	Unfortunately the company ended the contract with Mr. Kamel Mohamed (SSN=223344) 
		so try to delete his data from your database in case you know that you will be temporarily in his position. 
	Hint: ( Check if Mr. Kamel has dependents, 
		    works as a department manager, 
		    supervises any employees or works in any projects )
		  and handle these cases
*/

-- CHECK
SELECT COUNT(*)
FROM Dependent
WHERE ESSN = 223344			-- Has 2 dependents

SELECT *
FROM Departments
WHERE MGRSSN = 223344		-- He was department manager (Dnum 10)

SELECT COUNT(*)
FROM Works_for
WHERE ESSn = 223344			-- works on 4 projects (100 , 200 , 300 , 500)

SELECT COUNT(*)
FROM Employee
WHERE Superssn = 223344		-- supervises 2 employees (112233 , 123456)

-- TAKE HIS POSITION 
UPDATE Departments
	SET MGRSSN = 102672,
		[MGRStart Date] = GETDATE()
	WHERE MGRSSN = 223344

UPDATE Employee
	SET Superssn = 102672
	WHERE Superssn = 223344

UPDATE Works_for
	SET ESSn = 102672
	WHERE ESSn = 223344

-- DELETE
DELETE FROM Dependent
WHERE ESSN = 223344

DELETE FROM Employee
WHERE SSN = 223344



-- 4.	Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30% 

UPDATE Employee
	SET Salary += (Salary * 0.3)
	FROM Employee AS E 
	INNER JOIN Works_for AS W
		ON E.SSN = W.ESSn
	INNER JOIN Project AS P
		ON W.Pno = P.Pnumber
	WHERE P.Pname = 'Al Rabwah'