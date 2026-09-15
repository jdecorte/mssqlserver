-- Session 1
-- run complete session at once
use Northwind
-- step 1
BEGIN TRAN
-- Uses default isolation level READ COMMITTED
SELECT EmployeeID,Salary from Employees 
where EmployeeID=1;

UPDATE Employees SET Salary = Salary+5000 
where EmployeeID=1;

SELECT EmployeeID,Salary from Employees 
where EmployeeID=1;
-- simulates delay, allows session 2 to start
WAITFOR DELAY '00:00:10'

-- step 3
print 'session 1 continues with step 3'
SELECT employeeid,salary from Employees 
where EmployeeID=2;
-- Session 1 has to wait because session 2 holds 
-- an exclusive lock on this record

-- step 5
COMMIT TRAN -- does not work for victim

-- End of session 1

