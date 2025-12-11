USE Company_SD
GO

-- 1.	Display the Department id, name and id and the name of its manager.

SELECT 
	D.Dnum AS [department id], 
	D.Dname AS [department name], 
	E.SSN AS [employee id], 
	CONCAT(E.Fname, ' ', E.Lname) AS [employee name]
FROM Departments D 
INNER JOIN Employee E
	ON D.MGRSSN = E.SSN


-- 2.	Display the name of the departments and the name of the projects under its control.

SELECT 
	D.Dname AS [department name], 
	P.Pname AS [project name]
FROM Departments D 
INNER JOIN Project P
	ON D.Dnum = P.Dnum


-- 3.	Display the full data about all the dependence associated with the name of the employee they depend on him/her.

SELECT 
	CONCAT(E.Fname, ' ', E.Lname) AS [employee name],
	D.*
FROM Employee AS E
INNER JOIN Dependent AS D
	ON E.SSN = D.ESSN


-- 4.	Display the Id, name and location of the projects in Cairo or Alex city.

SELECT 
	Pnumber, 
	Pname, 
	City
FROM Project
WHERE City IN('Cairo', 'Alex')


-- 5.	Display the Projects full data of the projects with a name starts with "a" letter.

SELECT *
FROM Project
WHERE Pname LIKE 'A%'


-- 6.	display all the employees in department 30 whose salary from 1000 to 2000 LE monthly

SELECT *
FROM Employee
WHERE (Dno = 30) AND Salary BETWEEN 1000 AND 2000


-- 7.	Retrieve the names of all employees in department 10 who works more than or equal 10 hours per week on "AL Rabwah" project.

SELECT CONCAT(Fname, ' ', Lname) AS [Employee Name]
FROM Employee AS E
INNER JOIN Works_for AS W
	ON E.SSN = W.ESSn
INNER JOIN Project AS P
	ON W.Pno = P.Pnumber
WHERE 
	(Dno = 10) 
	AND (W.Hours >= 10) 
	AND Pname = 'AL Rabwah'


-- 8.	Find the names of the employees who directly supervised with Kamel Mohamed.

SELECT 
	CONCAT(E.Fname,' ', E.Lname) AS [Employee], 
	CONCAT(S.Fname,' ', S.Lname) AS [Super]
FROM Employee E										-- CHILD  has(FK) | has(super name)		main
INNER JOIN Employee S								-- PARENT has(PK) | has(employee name)  copy
	ON E.Superssn = S.SSN


-- 9.	Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name.

SELECT 
	CONCAT(E.Fname,' ', E.Lname) AS [Employee],
	P.Pname AS [Project]
FROM Employee AS E
INNER JOIN Works_for AS W
	ON E.SSN = W.ESSn
INNER JOIN Project AS P
	ON W.Pno = P.Pnumber
ORDER BY Pname


/* 10.	For each project located in Cairo City ,							(project table)
		find the project number ,										    (project table)
		the controlling department name ,									(department)
		the department manager last name , address and birthdate.           (employee)
*/

SELECT 
	P.Pnumber AS [Project Number],
	D.Dname AS [Department Name],
	E.Lname AS [Department Manager],
	E.Address AS [Manager Address],
	E.Bdate AS [Manager Birthdate]
FROM Project AS P
INNER JOIN Departments AS D
	ON P.Dnum = D.Dnum
INNER JOIN Employee AS E
	ON D.MGRSSN = E.SSN
WHERE 
	P.City = 'Cairo'


-- 11.	Display All Data of the mangers

SELECT DISTINCT E.*
FROM Employee AS E
INNER JOIN Departments AS D
	ON E.SSN = D.MGRSSN


-- 12.	Display All Employees data and the data of their dependents even if they have no dependents

SELECT E.* , D.*
FROM Employee AS E
LEFT JOIN Dependent AS D
	ON E.SSN = D.ESSN


-- Data Manipulating Language:

/* 1.	Insert your personal data to the employee table as a new employee in 
			department number 30, 
			SSN = 102672, 
			Superssn = 112233, 
			salary=3000.
*/

INSERT INTO Employee 
	VALUES('Mohamed', 'Bashar', 102672, '2005-01-10', 'Mansoura', 'M', 3000, 321654, 30)

/* 2.	Insert another employee with personal data your friend as new employee in 
			department number 30, 
			SSN = 102660, 
			but don’t enter any value for salary or manager number to him.
*/

INSERT INTO Employee
	VALUES('Mohamed', 'Elsayed', 102660, '1999-11-25', 'Tanta Elgalaa street', 'M', NULL, NULL, 30)


-- 3.	Upgrade your salary by 20 % of its last value.

UPDATE Employee
	SET Salary += (Salary*0.2)
WHERE SSN = 102672
