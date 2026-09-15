-- SESSION 2
USE TestDB
begin transaction
-- execute up to next select after execution of all lines 
-- except last one in session 1
select * from customers;
-- now execute the last line in session 1
-- then execute next line
select * from customers;
commit 
-- Which concurrency problem is illustrated and how can you fix it? 