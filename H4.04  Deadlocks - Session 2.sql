-- Session 2
-- run complete session at once
-- start session 2 < 10 secs after session 1
use Northwind
-- step 2
BEGIN TRAN
-- Uses default isolation level READ COMMITTED
SELECT EmployeeID,Salary from Employees 
where EmployeeID=2;

UPDATE Employees SET Salary = Salary+5000 
where EmployeeID=2;

SELECT EmployeeID,Salary from Employees 
where EmployeeID=2;
-- simulates delay, allows session 1 to continue
WAITFOR DELAY '00:00:10'

-- step 4
SELECT employeeid,salary from Employees 
where EmployeeID=1;
-- Session 2 has to wait too because 
-- session 1 holds an exclusive lock on this record
-- A deadlock occurs and one of the sessions 
-- is chosen as the victim

-- step 6 
COMMIT TRAN -- does not work for victim

-- End of session 2